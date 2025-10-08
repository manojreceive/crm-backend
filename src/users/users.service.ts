import { Injectable } from '@nestjs/common';
import * as sql from 'mssql';

@Injectable()
export class UsersService {
  private async getPool() {
    return sql.connect(process.env.DB_CONN_STRING);
  }

  async findByEmail(email: string) {
    const pool = await this.getPool();
    const result = await pool.request()
      .input('email', sql.NVarChar, email)
      .query(`SELECT TOP 1 * FROM Users WHERE Email = @email AND IsActive = 1`);
    return result.recordset[0];
  }

  async getUserRoles(userId: number) {
    const pool = await this.getPool();
    const result = await pool.request()
      .input('userId', sql.Int, userId)
      .query(`
        SELECT r.RoleName
        FROM UserRoles ur
        INNER JOIN Roles r ON ur.RoleId = r.RoleId
        WHERE ur.UserId = @userId
      `);
    return result.recordset.map(r => r.RoleName);
  }

  async getUserPermissions(userId: number) {
    const pool = await this.getPool();
    const result = await pool.request()
      .input('userId', sql.Int, userId)
      .query(`
        SELECT DISTINCT p.Code
        FROM UserRoles ur
        INNER JOIN Roles r ON ur.RoleId = r.RoleId
        INNER JOIN RolePermissions rp ON rp.RoleId = r.RoleId
        INNER JOIN Permissions p ON p.PermissionId = rp.PermissionId
        WHERE ur.UserId = @userId
      `);
    return result.recordset.map(p => p.Code);
  }
}
