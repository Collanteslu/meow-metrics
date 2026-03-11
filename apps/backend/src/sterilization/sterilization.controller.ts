import { Body, Controller, Post, Get, Patch, Param, UseGuards, Request, Query } from '@nestjs/common';
import { SterilizationService } from './sterilization.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Sterilization (CER)')
@ApiBearerAuth()
@Controller('sterilizations')
@UseGuards(JwtAuthGuard)
export class SterilizationController {
  constructor(private readonly service: SterilizationService) {}

  @Post()
  async create(@Body() input: any, @Request() req) {
    return this.service.create(input, req.user.id);
  }

  @Get('by-colony/:colonyId')
  async findByColony(@Param('colonyId') colonyId: string) {
    return this.service.findByColony(colonyId);
  }

  @Get('stats/:colonyId')
  async getStats(@Param('colonyId') colonyId: string) {
    return this.service.getStats(colonyId);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() input: any, @Request() req) {
    return this.service.update(id, input, req.user.id);
  }
}
