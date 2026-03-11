import { Body, Controller, Post, Get, Patch, Param, UseGuards, Request } from '@nestjs/common';
import { HealthService } from './health.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Health Records')
@ApiBearerAuth()
@Controller('health')
@UseGuards(JwtAuthGuard)
export class HealthController {
  constructor(private readonly service: HealthService) {}

  @Post()
  async create(@Body() input: any, @Request() req) {
    return this.service.create(input, req.user.id);
  }

  @Get('by-cat/:catId')
  async findByCat(@Param('catId') catId: string) {
    return this.service.findByCat(catId);
  }

  @Get('by-colony/:colonyId')
  async findByColony(@Param('colonyId') colonyId: string) {
    return this.service.findByColony(colonyId);
  }

  @Get('stats/:colonyId')
  async getStats(@Param('colonyId') colonyId: string) {
    return this.service.getHealthStats(colonyId);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() input: any) {
    return this.service.update(id, input);
  }
}
