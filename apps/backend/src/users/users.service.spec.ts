import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { DatabaseService } from '../database/database.service';

describe('UsersService', () => {
  let service: UsersService;
  let databaseService: DatabaseService;

  const mockUser = {
    id: '1',
    email: 'test@example.com',
    password: '$2a$10$hashed',
    role: 'coordinator',
    name: 'Test User',
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: DatabaseService,
          useValue: {
            user: {
              findUnique: jest.fn(),
              create: jest.fn(),
              update: jest.fn(),
              delete: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    databaseService = module.get<DatabaseService>(DatabaseService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findByEmail', () => {
    it('should return user by email', async () => {
      jest.spyOn(databaseService.user, 'findUnique').mockResolvedValue(mockUser);

      const result = await service.findByEmail('test@example.com');

      expect(result).toEqual(mockUser);
      expect(databaseService.user.findUnique).toHaveBeenCalledWith({
        where: { email: 'test@example.com' },
      });
    });

    it('should return null if user not found', async () => {
      jest.spyOn(databaseService.user, 'findUnique').mockResolvedValue(null);

      const result = await service.findByEmail('notfound@example.com');

      expect(result).toBeNull();
    });
  });

  describe('findById', () => {
    it('should return user by id', async () => {
      jest.spyOn(databaseService.user, 'findUnique').mockResolvedValue(mockUser);

      const result = await service.findById('1');

      expect(result).toEqual(mockUser);
    });
  });

  describe('create', () => {
    it('should create a new user', async () => {
      const input = {
        email: 'new@example.com',
        password: 'hashed',
        role: 'volunteer',
      };

      jest.spyOn(databaseService.user, 'create').mockResolvedValue({
        ...mockUser,
        ...input,
      });

      const result = await service.create(input);

      expect(result.email).toBe(input.email);
      expect(databaseService.user.create).toHaveBeenCalled();
    });
  });

  describe('update', () => {
    it('should update user profile', async () => {
      const updates = { name: 'Updated Name' };
      const updated = { ...mockUser, ...updates };

      jest.spyOn(databaseService.user, 'update').mockResolvedValue(updated);

      const result = await service.update('1', updates);

      expect(result.name).toBe(updates.name);
    });
  });

  describe('delete', () => {
    it('should delete user', async () => {
      jest.spyOn(databaseService.user, 'delete').mockResolvedValue(mockUser);

      const result = await service.delete('1');

      expect(result).toEqual(mockUser);
    });
  });
});
