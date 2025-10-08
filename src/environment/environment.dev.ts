import { EnvironmentConfig } from './environment.interface';

export const environment: EnvironmentConfig = {
  env: 'development',
  port: 3000,
  db: {
    server: 'DESKTOP-N0AU4E9\\SQLEXPRESS',
    database: 'CRM_DB',
    user: 'sa',
    password: 'admin@123'
  },
  jwt: {
    secret: 'dev-secret-key',
    expiresIn: '1d'
  }
};
