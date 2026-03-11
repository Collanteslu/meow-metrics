import { Module } from '@nestjs/common';
import { SterilizationService } from './sterilization.service';
import { SterilizationController } from './sterilization.controller';
import { DatabaseModule } from '../database/database.module';

@Module({
  imports: [DatabaseModule],
  providers: [SterilizationService],
  controllers: [SterilizationController],
  exports: [SterilizationService],
})
export class SterilizationModule {}
