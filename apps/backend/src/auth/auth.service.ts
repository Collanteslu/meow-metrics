import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { NotificationsService } from '../notifications/notifications.service';
import * as bcrypt from 'bcryptjs';
import { z } from 'zod';
import { NOTIFICATION_TYPES, NOTIFICATION_SUBJECTS } from '../notifications/notifications.constants';

const RegisterSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  role: z.enum(['volunteer', 'coordinator', 'admin']),
});

const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string(),
});

export type RegisterInput = z.infer<typeof RegisterSchema>;
export type LoginInput = z.infer<typeof LoginSchema>;

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly notifications: NotificationsService,
  ) {}

  async register(input: RegisterInput) {
    RegisterSchema.parse(input);

    const existing = await this.usersService.findByEmail(input.email);
    if (existing) {
      throw new BadRequestException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(input.password, 10);
    const user = await this.usersService.create({
      email: input.email,
      password: hashedPassword,
      role: input.role,
    });

    // Send welcome email (non-blocking)
    this.notifications
      .sendEmail({
        to: user.email,
        subject: NOTIFICATION_SUBJECTS[NOTIFICATION_TYPES.WELCOME],
        template: NOTIFICATION_TYPES.WELCOME,
        data: {
          name: user.email.split('@')[0],
          appUrl: process.env.APP_URL || 'http://localhost:3000',
        },
      })
      .catch((err) => {
        console.error('Failed to send welcome email:', err);
        // Don't throw - email failure shouldn't block user registration
      });

    const tokens = this.generateTokens(user);
    return {
      ...tokens,
      user: { id: user.id, email: user.email, role: user.role },
    };
  }

  async login(input: LoginInput) {
    LoginSchema.parse(input);

    const user = await this.usersService.findByEmail(input.email);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const validPassword = await this.comparePasswords(input.password, user.password);
    if (!validPassword) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const tokens = this.generateTokens(user);
    return {
      ...tokens,
      user: { id: user.id, email: user.email, role: user.role },
    };
  }

  async refresh(refreshToken: string) {
    try {
      const decoded = this.jwtService.verify(refreshToken);
      const user = await this.usersService.findById(decoded.sub);
      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      return this.generateTokens(user);
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  private generateTokens(user: any) {
    const payload = { sub: user.id, email: user.email, role: user.role };
    return {
      accessToken: this.jwtService.sign(payload, { expiresIn: '15m' }),
      refreshToken: this.jwtService.sign(payload, { expiresIn: '7d' }),
    };
  }

  async comparePasswords(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }
}
