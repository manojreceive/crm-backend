import { EnvironmentConfig } from './environment.interface';

export const environment: EnvironmentConfig = {
  env: 'uat',
  port: 4000,
  db: {
    server: 'uat-db-server',
    database: 'CRM_DB_UAT',
    user: 'uat_user',
    password: 'UAT@123'
  },
  jwt: {
    secret: 'uat-secret-key',
    expiresIn: '12h'
  }
};
