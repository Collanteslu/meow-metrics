import { Body, Controller, Post, Get, Param, UseGuards, Request, Query } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Reports & Analytics')
@ApiBearerAuth()
@Controller('reports')
@UseGuards(JwtAuthGuard)
export class ReportsController {
  constructor(private readonly service: ReportsService) {}

  @Get('colony/:colonyId/stats')
  async getColonyStats(@Param('colonyId') colonyId: string) {
    return this.service.getColonyStats(colonyId);
  }

  @Get('user/stats')
  async getUserStats(@Request() req) {
    return this.service.getUserStats(req.user.id);
  }

  @Post('colony/:colonyId/generate')
  async generateReport(
    @Param('colonyId') colonyId: string,
    @Body() input: { startDate: string; endDate: string },
  ) {
    return this.service.generateReport(
      colonyId,
      new Date(input.startDate),
      new Date(input.endDate),
    );
  }

  @Get('colony/:colonyId')
  async getReports(@Param('colonyId') colonyId: string) {
    return this.service.getReports(colonyId);
  }
}
