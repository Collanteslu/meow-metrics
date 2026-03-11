import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { z } from 'zod';

const CreateColonySchema = z.object({
  name: z.string().min(3),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  address: z.string(),
  city: z.string(),
  description: z.string().optional(),
  estimatedPopulation: z.number().optional(),
});

const UpdateColonySchema = CreateColonySchema.partial();

export type CreateColonyInput = z.infer<typeof CreateColonySchema>;
export type UpdateColonyInput = z.infer<typeof UpdateColonySchema>;

@Injectable()
export class ColoniesService {
  constructor(private readonly db: DatabaseService) {}

  async create(input: CreateColonyInput, userId: string) {
    CreateColonySchema.parse(input);

    const location = await this.db.location.create({
      data: {
        latitude: input.latitude,
        longitude: input.longitude,
        address: input.address,
        city: input.city,
      },
    });

    return this.db.colony.create({
      data: {
        name: input.name,
        locationId: location.id,
        ownerId: userId,
        description: input.description,
        estimatedPopulation: input.estimatedPopulation,
      },
      include: { location: true, owner: true },
    });
  }

  async findAll(userId: string, filters?: any) {
    return this.db.colony.findMany({
      where: {
        OR: [{ ownerId: userId }, { collaborators: { some: { userId } } }],
      },
      include: { location: true, owner: true, _count: { select: { cats: true } } },
      skip: filters?.skip || 0,
      take: filters?.take || 20,
    });
  }

  async findById(id: string) {
    const colony = await this.db.colony.findUnique({
      where: { id },
      include: { location: true, owner: true, cats: true, collaborators: true },
    });

    if (!colony) throw new NotFoundException('Colony not found');
    return colony;
  }

  async update(id: string, input: UpdateColonyInput, userId: string) {
    UpdateColonySchema.parse(input);

    const colony = await this.findById(id);
    if (colony.ownerId !== userId) {
      throw new ForbiddenException('Only owner can update colony');
    }

    return this.db.colony.update({
      where: { id },
      data: input,
      include: { location: true, owner: true },
    });
  }

  async delete(id: string, userId: string) {
    const colony = await this.findById(id);
    if (colony.ownerId !== userId) {
      throw new ForbiddenException('Only owner can delete colony');
    }

    return this.db.colony.delete({
      where: { id },
    });
  }
}
