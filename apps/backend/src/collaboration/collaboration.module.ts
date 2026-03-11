import { Module } from '@nestjs/common';
import { CollaborationService } from './collaboration.service';
import { CollaborationController } from './collaboration.controller';
import { DatabaseModule } from '../database/database.module';

@Module({
  imports: [DatabaseModule],
  providers: [CollaborationService],
  controllers: [CollaborationController],
  exports: [CollaborationService],
})
export class CollaborationModule {}
