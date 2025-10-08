import { EnvironmentConfig } from './environment.interface';

export const environment: EnvironmentConfig = {
  env: 'development',
  port: 3000,
  db: {
    server: '.\\SQLEXPRESS',
    database: 'CRM_DB',
    user: 'sa',
    password: 'admin@123'
  },
  jwt: {
    secret: 'dev-secret-key',
    expiresIn: '1d'
  }
};
