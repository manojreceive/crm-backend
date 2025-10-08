import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { UsersService } from '../../users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService
  ) {}

  async validateUser(email: string, password: string) {
    const user = await this.usersService.findByEmail(email);
    if (user && await bcrypt.compare(password, user.PasswordHash)) {
      // fetch roles + permissions
      const roles = await this.usersService.getUserRoles(user.UserId);
      const permissions = await this.usersService.getUserPermissions(user.UserId);

      const { PasswordHash, ...result } = user;
      return { ...result, roles, permissions };
    }
    return null;
  }

  async login(user: any) {
    const payload = {
      sub: user.UserId,
      email: user.Email,
      tenantId: user.TenantId,
      roles: user.roles,
      permissions: user.permissions,
    };
    return {
      access_token: this.jwtService.sign(payload),
      user,
    };
  }
}
