import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class HealthService {
  constructor(private readonly db: DatabaseService) {}

  async create(input: any, userId: string) {
    return this.db.healthRecord.create({
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
