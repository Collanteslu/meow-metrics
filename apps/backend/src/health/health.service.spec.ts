import { Test, TestingModule } from '@nestjs/testing';
import { HealthService } from './health.service';
import { DatabaseService } from '../database/database.service';
import { NotificationsService } from '../notifications/notifications.service';

describe('HealthService', () => {
  let service: HealthService;
  let mockDb: Partial<DatabaseService>;
  let mockNotifications: Partial<NotificationsService>;

  beforeEach(async () => {
    mockDb = {
      healthRecord: {
        create: jest.fn(),
        findMany: jest.fn(),
        update: jest.fn(),
      } as any,
      cat: {
        findUnique: jest.fn(),
      } as any,
      colony: {
        findUnique: jest.fn(),
      } as any,
      user: {
        findUnique: jest.fn(),
      } as any,
    };

    mockNotifications = {
      sendEmail: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthService,
        {
          provide: DatabaseService,
          useValue: mockDb,
        },
        {
          provide: NotificationsService,
          useValue: mockNotifications,
        },
      ],
    }).compile();

    service = module.get<HealthService>(HealthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should send health alert email for SICK records', async () => {
      const input = {
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'SICK',
        description: 'Fever and lethargy',
        veterinarian: 'Dr. Smith',
        medications: ['Antibiotics'],
        nextFollowup: new Date(),
      };

      const mockCat = {
        id: 'cat-123',
        name: 'Fluffy',
        colonyId: 'col-456',
      };

      const mockColony = {
        id: 'col-456',
        name: 'Downtown Colony',
        ownerId: 'owner-123',
      };

      const mockOwner = {
        id: 'owner-123',
        email: 'owner@example.com',
        name: 'Colony Owner',
      };

      const mockRecord = {
        id: 'record-123',
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'SICK',
        description: 'Fever and lethargy',
      };

      jest
        .spyOn(mockDb.healthRecord, 'create')
        .mockResolvedValue(mockRecord);
      jest
        .spyOn(mockDb.cat, 'findUnique')
        .mockResolvedValue(mockCat);
      jest
        .spyOn(mockDb.colony, 'findUnique')
        .mockResolvedValue(mockColony);
      jest
        .spyOn(mockDb.user, 'findUnique')
        .mockResolvedValue(mockOwner);

      await service.create(input, 'user-123');

      expect(mockNotifications.sendEmail).toHaveBeenCalledWith(
        expect.objectContaining({
          to: 'owner@example.com',
          template: 'health_alert',
          subject: 'Health alert for your cat',
          data: expect.objectContaining({
            catName: 'Fluffy',
            colonyName: 'Downtown Colony',
            healthStatus: 'SICK',
          }),
        }),
      );
    });

    it('should send health alert email for INJURED records', async () => {
      const input = {
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'INJURED',
        description: 'Cut paw',
        veterinarian: 'Dr. Smith',
        medications: [],
        nextFollowup: new Date(),
      };

      const mockCat = {
        id: 'cat-123',
        name: 'Mittens',
        colonyId: 'col-456',
      };

      const mockColony = {
        id: 'col-456',
        name: 'Downtown Colony',
        ownerId: 'owner-123',
      };

      const mockOwner = {
        id: 'owner-123',
        email: 'owner@example.com',
      };

      const mockRecord = {
        id: 'record-456',
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'INJURED',
        description: 'Cut paw',
      };

      jest
        .spyOn(mockDb.healthRecord, 'create')
        .mockResolvedValue(mockRecord);
      jest
        .spyOn(mockDb.cat, 'findUnique')
        .mockResolvedValue(mockCat);
      jest
        .spyOn(mockDb.colony, 'findUnique')
        .mockResolvedValue(mockColony);
      jest
        .spyOn(mockDb.user, 'findUnique')
        .mockResolvedValue(mockOwner);

      await service.create(input, 'user-123');

      expect(mockNotifications.sendEmail).toHaveBeenCalledWith(
        expect.objectContaining({
          to: 'owner@example.com',
          template: 'health_alert',
          subject: 'Health alert for your cat',
          data: expect.objectContaining({
            catName: 'Mittens',
            colonyName: 'Downtown Colony',
            healthStatus: 'INJURED',
          }),
        }),
      );
    });

    it('should NOT send email for non-critical health records', async () => {
      const input = {
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'CHECKUP',
        description: 'Regular checkup',
        veterinarian: 'Dr. Smith',
        medications: [],
        nextFollowup: new Date(),
      };

      const mockRecord = {
        id: 'record-789',
        catId: 'cat-123',
        colonyId: 'col-456',
        recordType: 'CHECKUP',
        description: 'Regular checkup',
      };

      jest
        .spyOn(mockDb.healthRecord, 'create')
        .mockResolvedValue(mockRecord);

      await service.create(input, 'user-123');

      expect(mockNotifications.sendEmail).not.toHaveBeenCalled();
    });
  });
});
