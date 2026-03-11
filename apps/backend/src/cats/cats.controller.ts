import { Body, Controller, Post, Get, Patch, Delete, Param, UseGuards, Request, Query } from '@nestjs/common';
import { CatsService } from './cats.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Cats')
@ApiBearerAuth()
@Controller('cats')
@UseGuards(JwtAuthGuard)
export class CatsController {
  constructor(private readonly catsService: CatsService) {}

  @Post()
  async create(@Body() input: any, @Request() req) {
    return this.catsService.create(input, req.user.id);
  }

  @Get()
  async findByColony(@Query('colonyId') colonyId: string) {
    return this.catsService.findByColony(colonyId);
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return this.catsService.findById(id);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() input: any) {
    return this.catsService.update(id, input);
  }

  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.catsService.delete(id);
  }
}
