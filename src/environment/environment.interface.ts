export interface EnvironmentConfig {
  env: string;
  port: number;
  db: {
    server: string;
    database: string;
    user: string;
    password: string;
  };
  jwt: {
    secret: string;
    expiresIn: string;
  };
}
