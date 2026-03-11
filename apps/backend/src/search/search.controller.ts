import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { SearchService } from './search.service';
import { SearchResponseDto } from './search.dto';

@ApiTags('Search')
@Controller('search')
@UseGuards(JwtAuthGuard)
export class SearchController {
  constructor(private searchService: SearchService) {}

  @Get()
  @ApiQuery({
    name: 'q',
    required: false,
    description: 'Search query string',
    type: String,
  })
  @ApiQuery({
    name: 'type',
    required: false,
    description: 'Entity type to search: colonies, cats, users, or all',
    enum: ['colonies', 'cats', 'users', 'all'],
  })
  @ApiQuery({
    name: 'status',
    required: false,
    description: 'Filter by colony status',
    type: String,
  })
  @ApiQuery({
    name: 'healthStatus',
    required: false,
    description: 'Filter by cat health status',
    type: String,
  })
  @ApiQuery({
    name: 'gender',
    required: false,
    description: 'Filter by cat gender',
    type: String,
  })
  @ApiQuery({
    name: 'role',
    required: false,
    description: 'Filter by user role',
    type: String,
  })
  @ApiQuery({
    name: 'skip',
    required: false,
    description: 'Number of results to skip',
    type: Number,
  })
  @ApiQuery({
    name: 'take',
    required: false,
    description: 'Number of results to return',
    type: Number,
  })
  @ApiResponse({
    status: 200,
    description: 'Search results',
    type: SearchResponseDto,
  })
  async search(
    @Query('q') query?: string,
    @Query('type') type?: 'colonies' | 'cats' | 'users' | 'all',
    @Query('status') status?: string,
    @Query('healthStatus') healthStatus?: string,
    @Query('gender') gender?: string,
    @Query('role') role?: string,
    @Query('skip') skip?: string,
    @Query('take') take?: string,
  ): Promise<SearchResponseDto> {
    const filters: Record<string, any> = {};
    if (status) filters.status = status;
    if (healthStatus) filters.healthStatus = healthStatus;
    if (gender) filters.gender = gender;
    if (role) filters.role = role;

    return this.searchService.search({
      query,
      type: type || 'all',
      filters,
      skip: parseInt(skip) || 0,
      take: parseInt(take) || 20,
    });
  }
}
