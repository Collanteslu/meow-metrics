import { Body, Controller, Post, Get, Patch, Delete, Param, UseGuards, Request, Query } from '@nestjs/common';
import { ColoniesService } from './colonies.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Colonies')
@ApiBearerAuth()
@Controller('colonies')
@UseGuards(JwtAuthGuard)
export class ColoniesController {
  constructor(private readonly coloniesService: ColoniesService) {}

  @Post()
  async create(@Body() input: any, @Request() req) {
    return this.coloniesService.create(input, req.user.id);
  }

  @Get()
  async findAll(@Request() req, @Query() filters: any) {
    return this.coloniesService.findAll(req.user.id, filters);
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return this.coloniesService.findById(id);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() input: any, @Request() req) {
    return this.coloniesService.update(id, input, req.user.id);
  }

  @Delete(':id')
  async delete(@Param('id') id: string, @Request() req) {
    return this.coloniesService.delete(id, req.user.id);
  }
}
