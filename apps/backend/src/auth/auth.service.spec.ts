import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import { NotificationsService } from '../notifications/notifications.service';
import { BadRequestException, UnauthorizedException } from '@nestjs/common';

describe('AuthService', () => {
  let service: AuthService;
  let mockUsersService: any;
  let mockJwtService: any;
  let mockNotificationsService: any;

  const mockUser = {
    id: '1',
    email: 'test@example.com',
    password: '$2a$10$hashed',
    role: 'COORDINATOR' as const,
    status: 'ACTIVE' as const,
    name: 'Test User',
    phone: null,
    profilePhotoUrl: null,
    lastLogin: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    mockUsersService = {
      findByEmail: jest.fn(),
      create: jest.fn(),
      findById: jest.fn(),
    };

    mockJwtService = {
      sign: jest.fn(),
      verify: jest.fn(),
    };

    mockNotificationsService = {
      sendEmail: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UsersService,
          useValue: mockUsersService,
        },
        {
          provide: JwtService,
          useValue: mockJwtService,
        },
        {
          provide: NotificationsService,
          useValue: mockNotificationsService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('register', () => {
    it('should create a new user with hashed password', async () => {
      const input = { email: 'new@example.com', password: 'password123', role: 'volunteer' as const };
      const created = { ...mockUser, email: input.email, role: 'VOLUNTEER' as const };

      mockUsersService.findByEmail.mockResolvedValue(null);
      mockUsersService.create.mockResolvedValue(created);
      mockJwtService.sign.mockReturnValue('token');

      const result = await service.register(input);

      expect(result.user.email).toBe(input.email);
      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });

    it('should throw error if email already exists', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      await expect(
        service.register({ email: 'test@example.com', password: 'password123', role: 'volunteer' as const }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should validate password strength', async () => {
      await expect(
        service.register({ email: 'test@example.com', password: '123', role: 'volunteer' as const }),
      ).rejects.toThrow();
    });

    it('should send welcome email after successful registration', async () => {
      const newMockUser = {
        id: '123',
        email: 'newuser@example.com',
        password: '$2a$10$hashed',
        role: 'VOLUNTEER' as const,
        status: 'ACTIVE' as const,
        name: 'New User',
        phone: null,
        profilePhotoUrl: null,
        lastLogin: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      mockUsersService.findByEmail.mockResolvedValue(null);
      mockUsersService.create.mockResolvedValue(newMockUser);
      mockJwtService.sign.mockReturnValue('token');

      const result = await service.register({
        email: 'newuser@example.com',
        password: 'Password123!',
        role: 'volunteer' as const,
      });

      expect(result.accessToken).toBeDefined();
      // Wait a moment for the non-blocking email to be sent
      await new Promise((resolve) => setTimeout(resolve, 100));

      expect(mockNotificationsService.sendEmail).toHaveBeenCalledWith(
        expect.objectContaining({
          to: 'newuser@example.com',
          template: 'welcome',
          subject: 'Welcome to Meow Metrics!',
        }),
      );
    });
  });

  describe('login', () => {
    it('should return tokens for valid credentials', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);
      jest.spyOn(service, 'comparePasswords').mockResolvedValue(true);
      mockJwtService.sign.mockReturnValue('token');

      const result = await service.login({ email: 'test@example.com', password: 'password' });

      expect(result.accessToken).toBe('token');
      expect(result.refreshToken).toBe('token');
      expect(result.user).toBeDefined();
    });

    it('should throw error for invalid email', async () => {
      mockUsersService.findByEmail.mockResolvedValue(null);

      await expect(
        service.login({ email: 'invalid@example.com', password: 'password' }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should throw error for invalid password', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);
      jest.spyOn(service, 'comparePasswords').mockResolvedValue(false);

      await expect(
        service.login({ email: 'test@example.com', password: 'wrong' }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('refresh', () => {
    it('should return new tokens for valid refresh token', async () => {
      const decoded = { sub: '1', email: 'test@example.com' };
      mockJwtService.verify.mockReturnValue(decoded);
      mockUsersService.findById.mockResolvedValue(mockUser);
      mockJwtService.sign.mockReturnValue('newtoken');

      const result = await service.refresh('refresh-token');

      expect(result.accessToken).toBe('newtoken');
      expect(result.refreshToken).toBe('newtoken');
    });

    it('should throw error for invalid refresh token', async () => {
      mockJwtService.verify.mockImplementation(() => {
        throw new Error('Invalid token');
      });

      await expect(service.refresh('invalid-token')).rejects.toThrow();
    });
  });
});
