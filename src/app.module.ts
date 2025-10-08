import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { PermissionsModule } from './permissions/permissions.module';
import { RolesModule } from './roles/roles.module';
import { TenantsModule } from './tenants/tenants.module';
import { SubscriptionsModule } from './subscriptions/subscriptions.module';
import { LeadsModule } from './leads/leads.module';
import { ActivitiesModule } from './activities/activities.module';
import { JobsModule } from './jobs/queue.module';

@Module({
  imports: [
    ConfigModule.forRoot({ /* config options */ }),
    TypeOrmModule.forRoot({ /* database connection options */ }),
    UsersModule,
    AuthModule,
    PermissionsModule,
    RolesModule,
    TenantsModule,
    SubscriptionsModule,
    LeadsModule,
    ActivitiesModule,
    JobsModule,
  ],
})
export class AppModule {}