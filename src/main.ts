// Entry point for the application
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv';
const express = require('express');
const app = express();

// Enable the morgan middleware



dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  try {
    await app.listen(3000);
    console.log('Application is running on port 3000!');
  } catch (error) {
    console.error('An error occurred during startup:', error);
    process.exit(1);
  }
}
bootstrap();