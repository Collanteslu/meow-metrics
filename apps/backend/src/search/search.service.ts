import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { SearchResponseDto, SearchResultDto } from './search.dto';

export interface SearchParams {
  query?: string;
  type?: 'colonies' | 'cats' | 'users' | 'all';
  filters?: Record<string, any>;
  skip?: number;
  take?: number;
}

@Injectable()
export class SearchService {
  constructor(private db: DatabaseService) {}

  async search(params: SearchParams): Promise<SearchResponseDto> {
    const { query, type = 'all', filters = {}, skip = 0, take = 20 } = params;
    const results: SearchResultDto[] = [];
    let total = 0;

    if (type === 'all' || type === 'colonies') {
      const { results: colonyResults, count } = await this.searchColonies(
        query,
        filters,
        skip,
        take,
      );
      results.push(...colonyResults);
      total += count;
    }

    if (type === 'all' || type === 'cats') {
      const { results: catResults, count } = await this.searchCats(
        query,
        filters,
        skip,
        take,
      );
      results.push(...catResults);
      total += count;
    }

    if (type === 'all' || type === 'users') {
      const { results: userResults, count } = await this.searchUsers(
        query,
        filters,
        skip,
        take,
      );
      results.push(...userResults);
      total += count;
    }

    const limited = results.slice(0, take);
    return {
      results: limited,
      total: limited.length,
      hasMore: results.length > take,
    };
  }

  private async searchColonies(
    query: string | undefined,
    filters: Record<string, any>,
    skip: number,
    take: number,
  ): Promise<{ results: SearchResultDto[]; count: number }> {
    const whereConditions: any = { AND: [] };

    if (query) {
      whereConditions.AND.push({
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { description: { contains: query, mode: 'insensitive' } },
        ],
      });
    }

    if (filters.status) {
      whereConditions.AND.push({ status: filters.status });
    }

    if (filters.city) {
      whereConditions.AND.push({
        location: { city: { contains: filters.city, mode: 'insensitive' } },
      });
    }

    const colonies = await this.db.colony.findMany({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
      skip,
      take,
      include: { location: true },
    });

    const count = await this.db.colony.count({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
    });

    return {
      results: colonies.map((c) => ({
        id: c.id,
        type: 'colony' as const,
        title: c.name || 'Unnamed Colony',
        description: c.description || undefined,
        metadata: { status: c.status, city: c.location?.city },
      })),
      count,
    };
  }

  private async searchCats(
    query: string | undefined,
    filters: Record<string, any>,
    skip: number,
    take: number,
  ): Promise<{ results: SearchResultDto[]; count: number }> {
    const whereConditions: any = { AND: [] };

    if (query) {
      whereConditions.AND.push({
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { microchip: { contains: query, mode: 'insensitive' } },
        ],
      });
    }

    if (filters.healthStatus) {
      whereConditions.AND.push({ healthStatus: filters.healthStatus });
    }

    if (filters.gender) {
      whereConditions.AND.push({ gender: filters.gender });
    }

    const cats = await this.db.cat.findMany({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
      skip,
      take,
    });

    const count = await this.db.cat.count({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
    });

    return {
      results: cats.map((c) => ({
        id: c.id,
        type: 'cat' as const,
        title: c.name || 'Unnamed Cat',
        description: `${c.color || 'Unknown Color'} ${c.gender || 'Unknown Gender'}`,
        metadata: {
          healthStatus: c.healthStatus,
          color: c.color || undefined,
          gender: c.gender,
        },
      })),
      count,
    };
  }

  private async searchUsers(
    query: string | undefined,
    filters: Record<string, any>,
    skip: number,
    take: number,
  ): Promise<{ results: SearchResultDto[]; count: number }> {
    const whereConditions: any = { AND: [] };

    if (query) {
      whereConditions.AND.push({
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { email: { contains: query, mode: 'insensitive' } },
        ],
      });
    }

    if (filters.role) {
      whereConditions.AND.push({ role: filters.role });
    }

    const users = await this.db.user.findMany({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
      skip,
      take,
    });

    const count = await this.db.user.count({
      where: whereConditions.AND.length > 0 ? whereConditions : {},
    });

    return {
      results: users.map((u) => ({
        id: u.id,
        type: 'user' as const,
        title: u.name || 'Unnamed User',
        description: u.email || undefined,
        metadata: { role: u.role },
      })),
      count,
    };
  }
}
