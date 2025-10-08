import * as dotenv from 'dotenv';
import * as path from 'path';

// Load environment variables based on NODE_ENV
const envFile = `.env${process.env.NODE_ENV ? `.${process.env.NODE_ENV}` : ''}`;
dotenv.config({ path: path.resolve(process.cwd(), envFile) });

export const config = {
	env: process.env.NODE_ENV || 'development',
	db: {
		host: process.env.DB_HOST,
		port: process.env.DB_PORT,
		user: process.env.DB_USER,
		password: process.env.DB_PASSWORD,
		name: process.env.DB_NAME,
	},
};
