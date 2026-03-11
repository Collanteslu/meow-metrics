import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { NotificationsService } from '../notifications/notifications.service';
import { NOTIFICATION_TYPES, NOTIFICATION_SUBJECTS } from '../notifications/notifications.constants';

@Injectable()
export class CollaborationService {
  constructor(
    private readonly db: DatabaseService,
    private readonly notifications: NotificationsService,
  ) {}

  async invite(input: any, userId: string) {
    const collaboration = await this.db.collaborator.create({
      data: {
        colonyId: input.colonyId,
        userId: input.userId,
        role: input.role || 'VIEWER',
        invitedBy: userId,
      },
      include: { user: true, colony: true },
    });

    // Get inviter details
    const inviter = await this.db.user.findUnique({
      where: { id: userId },
    });

    // Send invitation email (non-blocking)
    this.notifications
      .sendEmail({
        to: collaboration.user.email,
        subject: NOTIFICATION_SUBJECTS[NOTIFICATION_TYPES.INVITATION_SENT],
        template: NOTIFICATION_TYPES.INVITATION_SENT,
        data: {
          inviter: inviter?.email || 'A user',
          colonyName: collaboration.colony.name,
          role: collaboration.role,
          colonyId: collaboration.colony.id,
          appUrl: process.env.APP_URL || 'http://localhost:3000',
        },
      })
      .catch((err) => {
        console.error('Failed to send invitation email:', err);
      });

    return collaboration;
  }

  async accept(id: string, userId: string) {
    const invite = await this.db.collaborator.findUnique({
      where: { id },
    });

    if (!invite || invite.userId !== userId) {
      throw new ForbiddenException('Cannot accept this invitation');
    }

    return this.db.collaborator.update({
      where: { id },
      data: { status: 'ACCEPTED', acceptedAt: new Date() },
    });
  }

  async reject(id: string, userId: string) {
    const invite = await this.db.collaborator.findUnique({
      where: { id },
    });

    if (!invite || invite.userId !== userId) {
      throw new ForbiddenException('Cannot reject this invitation');
    }

    return this.db.collaborator.update({
      where: { id },
      data: { status: 'REJECTED' },
    });
  }

  async getCollaborators(colonyId: string) {
    return this.db.collaborator.findMany({
      where: { colonyId, status: 'ACCEPTED' },
      include: { user: true },
    });
  }

  async removeCollaborator(id: string, userId: string) {
    const collaborator = await this.db.collaborator.findUnique({
      where: { id },
      include: { colony: true },
    });

    if (collaborator.colony.ownerId !== userId) {
      throw new ForbiddenException('Only owner can remove collaborators');
    }

    return this.db.collaborator.delete({
      where: { id },
    });
  }
}
