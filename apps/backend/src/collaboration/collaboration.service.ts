import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class CollaborationService {
  constructor(private readonly db: DatabaseService) {}

  async invite(input: any, userId: string) {
    return this.db.collaborator.create({
      data: {
        colonyId: input.colonyId,
        userId: input.userId,
        role: input.role || 'VIEWER',
        invitedBy: userId,
      },
      include: { user: true, colony: true },
    });
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
