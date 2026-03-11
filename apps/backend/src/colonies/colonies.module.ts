import { Module } from '@nestjs/common';
import { ColoniesService } from './colonies.service';
import { ColoniesController } from './colonies.controller';
import { DatabaseModule } from '../database/database.module';

@Module({
  imports: [DatabaseModule],
  providers: [ColoniesService],
  controllers: [ColoniesController],
  exports: [ColoniesService],
})
export class ColoniesModule {}
