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
import { environment } from './environment/environment.dev';

@Module({
  imports: [
    ConfigModule.forRoot({ /* config options */ }),
    TypeOrmModule.forRoot({
      type: 'mssql',
      host: environment.db.server,
      port: 1433,
      username: environment.db.user,
      password: environment.db.password,
      database: environment.db.database,
      autoLoadEntities: true,
      synchronize: true,
      options: {
        encrypt: false
      }
    }),
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