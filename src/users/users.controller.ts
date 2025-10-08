import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/auth.guard';
import * as sql from 'mssql';


@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // List all users (protected)
  @UseGuards(JwtAuthGuard)
  @Get()
  async getAllUsers() {
    // WARNING: In real app, you should filter by TenantId
    const pool = await this.usersService['getPool']();
    const result = await pool.request().query(`SELECT UserId, TenantId, Email, DisplayName, IsActive FROM Users`);
    return result.recordset;
  }

  // Get user by id (protected)
  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async getUserById(@Param('id') id: number) {
    const pool = await this.usersService['getPool']();
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query(`SELECT UserId, TenantId, Email, DisplayName, IsActive FROM Users WHERE UserId = @id`);
    return result.recordset[0];
  }

  // Add user (open — for seeding/demo)
  @Post()
  async createUser(@Body() body: { tenantId: number, email: string, password: string, displayName: string }) {
    const bcrypt = require('bcryptjs');
    const hash = await bcrypt.hash(body.password, 10);

    const pool = await this.usersService['getPool']();
    await pool.request()
      .input('tenantId', sql.Int, body.tenantId)
      .input('email', sql.NVarChar, body.email)
      .input('displayName', sql.NVarChar, body.displayName)
      .input('passwordHash', sql.NVarChar, hash)
      .query(`
        INSERT INTO Users (TenantId, Email, DisplayName, AuthProvider, PasswordHash, IsActive)
        VALUES (@tenantId, @email, @displayName, 'Custom', @passwordHash, 1)
      `);

    return { message: 'User created successfully' };
  }
}
