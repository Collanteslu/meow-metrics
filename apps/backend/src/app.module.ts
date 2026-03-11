import { Module } from '@nestjs/common';
import { ConfigModule } from './config/config.module';
import { DatabaseModule } from './database/database.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ColoniesModule } from './colonies/colonies.module';
import { CatsModule } from './cats/cats.module';
import { SterilizationModule } from './sterilization/sterilization.module';
import { HealthModule } from './health/health.module';
import { CollaborationModule } from './collaboration/collaboration.module';
import { ReportsModule } from './reports/reports.module';
import { NotificationsModule } from './notifications/notifications.module';

@Module({
  imports: [
    ConfigModule,
    DatabaseModule,
    AuthModule,
    UsersModule,
    ColoniesModule,
    CatsModule,
    SterilizationModule,
    HealthModule,
    CollaborationModule,
    ReportsModule,
    NotificationsModule,
  ],
})
export class AppModule {}
