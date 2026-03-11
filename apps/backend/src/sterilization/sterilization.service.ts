import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class SterilizationService {
  constructor(private readonly db: DatabaseService) {}

  async create(input: any, userId: string) {
    return this.db.sterilization.create({
      data: {
        catId: input.catId,
        colonyId: input.colonyId,
        status: input.status || 'PENDING',
        recordedById: userId,
        scheduledDate: input.scheduledDate,
        veterinarian: input.veterinarian,
        clinicName: input.clinicName,
        cost: input.cost,
      },
    });
  }

  async findByColony(colonyId: string) {
    return this.db.sterilization.findMany({
      where: { colonyId },
      include: { cat: true },
    });
  }

  async update(id: string, input: any, userId: string) {
    return this.db.sterilization.update({
      where: { id },
      data: input,
    });
  }

  async getStats(colonyId: string) {
    const [total, completed, pending] = await Promise.all([
      this.db.sterilization.count({ where: { colonyId } }),
      this.db.sterilization.count({ where: { colonyId, status: 'COMPLETED' } }),
      this.db.sterilization.count({ where: { colonyId, status: 'PENDING' } }),
    ]);

    return { total, completed, pending, completionRate: total > 0 ? (completed / total) * 100 : 0 };
  }
}
