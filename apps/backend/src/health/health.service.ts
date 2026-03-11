import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { NotificationsService } from '../notifications/notifications.service';
import { NOTIFICATION_TYPES, NOTIFICATION_SUBJECTS } from '../notifications/notifications.constants';

@Injectable()
export class HealthService {
  constructor(
    private readonly db: DatabaseService,
    private readonly notifications: NotificationsService,
  ) {}

  async create(input: any, userId: string) {
    const record = await this.db.healthRecord.create({
      data: {
        catId: input.catId,
        colonyId: input.colonyId,
        recordType: input.recordType,
        description: input.description,
        veterinarian: input.veterinarian,
        medications: input.medications,
        nextFollowup: input.nextFollowup,
        recordedById: userId,
      },
    });

    // Send alert if health status is concerning
    if (['SICK', 'INJURED'].includes(input.recordType)) {
      try {
        const cat = await this.db.cat.findUnique({
          where: { id: input.catId },
        });

        const colony = await this.db.colony.findUnique({
          where: { id: input.colonyId },
        });

        const owner = await this.db.user.findUnique({
          where: { id: colony.ownerId },
        });

        // Send health alert email (non-blocking)
        this.notifications
          .sendEmail({
            to: owner.email,
            subject: NOTIFICATION_SUBJECTS[NOTIFICATION_TYPES.HEALTH_ALERT],
            template: NOTIFICATION_TYPES.HEALTH_ALERT,
            data: {
              catName: cat.name,
              colonyName: colony.name,
              healthStatus: input.recordType,
              catId: cat.id,
              appUrl: process.env.APP_URL || 'http://localhost:3000',
            },
          })
          .catch((err) => {
            console.error('Failed to send health alert email:', err);
          });
      } catch (err) {
        console.error('Error sending health alert:', err);
        // Don't throw - health record creation shouldn't fail due to email errors
      }
    }

    return record;
  }

  async findByCat(catId: string) {
    return this.db.healthRecord.findMany({
      where: { catId },
      orderBy: { dateRecorded: 'desc' },
    });
  }

  async findByColony(colonyId: string) {
    return this.db.healthRecord.findMany({
      where: { colonyId },
      include: { cat: true },
      orderBy: { dateRecorded: 'desc' },
    });
  }

  async update(id: string, input: any) {
    return this.db.healthRecord.update({
      where: { id },
      data: input,
    });
  }

  async getHealthStats(colonyId: string) {
    const records = await this.db.healthRecord.findMany({
      where: { colonyId },
      select: { recordType: true },
    });

    const stats = records.reduce((acc, r) => {
      acc[r.recordType] = (acc[r.recordType] || 0) + 1;
      return acc;
    }, {});

    return { total: records.length, byType: stats };
  }
}
