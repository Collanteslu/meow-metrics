import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class ReportsService {
  constructor(private readonly db: DatabaseService) {}

  async getColonyStats(colonyId: string) {
    const [cats, sterilizations, healthRecords] = await Promise.all([
      this.db.cat.count({ where: { colonyId } }),
      this.db.sterilization.count({ where: { colonyId } }),
      this.db.healthRecord.count({ where: { colonyId } }),
    ]);

    const sterilizationStats = await this.db.sterilization.groupBy({
      by: ['status'],
      where: { colonyId },
      _count: { id: true },
    });

    const healthRecordStats = await this.db.healthRecord.groupBy({
      by: ['recordType'],
      where: { colonyId },
      _count: { id: true },
    });

    return {
      colonyId,
      totalCats: cats,
      totalSterilizations: sterilizations,
      totalHealthRecords: healthRecords,
      sterilizationStats,
      healthRecordStats,
      timestamp: new Date(),
    };
  }

  async getUserStats(userId: string) {
    const [coloniesOwned, collaborations, healthRecordsCreated] = await Promise.all([
      this.db.colony.count({ where: { ownerId: userId } }),
      this.db.collaborator.count({ where: { userId, status: 'ACCEPTED' } }),
      this.db.healthRecord.count({ where: { recordedById: userId } }),
    ]);

    return {
      userId,
      coloniesOwned,
      collaborations,
      healthRecordsCreated,
      timestamp: new Date(),
    };
  }

  async generateReport(colonyId: string, startDate: Date, endDate: Date) {
    const healthRecords = await this.db.healthRecord.findMany({
      where: {
        colonyId,
        dateRecorded: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    const sterilizations = await this.db.sterilization.findMany({
      where: {
        colonyId,
        createdAt: {
          gte: startDate,
          lte: endDate,
        },
      },
    });

    return this.db.report.create({
      data: {
        colonyId,
        title: `Report for ${new Date().toLocaleDateString()}`,
        startDate,
        endDate,
        statistics: {
          healthRecordsCount: healthRecords.length,
          sterilizationsCount: sterilizations.length,
          records: healthRecords,
          sterilizations,
        } as any,
      },
    });
  }

  async getReports(colonyId: string) {
    return this.db.report.findMany({
      where: { colonyId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
