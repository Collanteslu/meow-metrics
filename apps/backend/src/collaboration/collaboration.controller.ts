import { Body, Controller, Post, Get, Patch, Delete, Param, UseGuards, Request } from '@nestjs/common';
import { CollaborationService } from './collaboration.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Collaboration')
@ApiBearerAuth()
@Controller('collaborations')
@UseGuards(JwtAuthGuard)
export class CollaborationController {
  constructor(private readonly service: CollaborationService) {}

  @Post('invite')
  async invite(@Body() input: any, @Request() req) {
    return this.service.invite(input, req.user.id);
  }

  @Patch('accept/:id')
  async accept(@Param('id') id: string, @Request() req) {
    return this.service.accept(id, req.user.id);
  }

  @Patch('reject/:id')
  async reject(@Param('id') id: string, @Request() req) {
    return this.service.reject(id, req.user.id);
  }

  @Get('colony/:colonyId')
  async getCollaborators(@Param('colonyId') colonyId: string) {
    return this.service.getCollaborators(colonyId);
  }

  @Delete(':id')
  async removeCollaborator(@Param('id') id: string, @Request() req) {
    return this.service.removeCollaborator(id, req.user.id);
  }
}
