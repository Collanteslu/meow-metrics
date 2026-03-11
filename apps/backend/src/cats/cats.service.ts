import { Injectable, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';

@Injectable()
export class CatsService {
  constructor(private readonly db: DatabaseService) {}

  async create(input: any, userId: string) {
    return this.db.cat.create({
      data: {
        colonyId: input.colonyId,
        name: input.name,
        microchip: input.microchip,
        color: input.color,
        gender: input.gender || 'UNKNOWN',
        notes: input.notes,
      },
    });
  }

  async findByColony(colonyId: string) {
    return this.db.cat.findMany({
      where: { colonyId },
      include: { sterilizations: true, healthRecords: true },
    });
  }

  async findById(id: string) {
    const cat = await this.db.cat.findUnique({
      where: { id },
      include: { sterilizations: true, healthRecords: true, colony: true },
    });

    if (!cat) throw new NotFoundException('Cat not found');
    return cat;
  }

  async update(id: string, input: any) {
    return this.db.cat.update({
      where: { id },
      data: input,
    });
  }

  async delete(id: string) {
    return this.db.cat.delete({
      where: { id },
    });
  }
}
