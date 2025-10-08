import { EnvironmentConfig } from './environment.interface';

export const environment: EnvironmentConfig = {
  env: 'production',
  port: 80,
  db: {
    server: 'prod-db-server',
    database: 'CRM_DB_PROD',
    user: 'prod_user',
    password: 'StrongProdPassword!'
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'fallback-secret',
    expiresIn: '6h'
  }
};
