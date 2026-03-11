import { Test, TestingModule } from '@nestjs/testing';
import { CollaborationService } from './collaboration.service';
import { DatabaseService } from '../database/database.service';
import { NotificationsService } from '../notifications/notifications.service';

describe('CollaborationService', () => {
  let service: CollaborationService;
  let mockDb: Partial<DatabaseService>;
  let mockNotifications: Partial<NotificationsService>;

  beforeEach(async () => {
    mockDb = {
      collaborator: {
        create: jest.fn(),
        findUnique: jest.fn(),
        update: jest.fn(),
        findMany: jest.fn(),
        delete: jest.fn(),
      } as any,
      user: {
        findUnique: jest.fn(),
      } as any,
      colony: {
        findUnique: jest.fn(),
      } as any,
      auditLog: {
        create: jest.fn(),
      } as any,
    };

    mockNotifications = {
      sendEmail: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CollaborationService,
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

    service = module.get<CollaborationService>(CollaborationService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('invite', () => {
    it('should send invitation email to invited user', async () => {
      const input = {
        colonyId: 'col-123',
        userId: 'user-456',
        role: 'VIEWER',
      };

      const mockUser = {
        id: 'user-456',
        email: 'collaborator@example.com',
        name: 'Collaborator Name',
      };

      const mockColony = {
        id: 'col-123',
        name: 'Downtown Colony',
        ownerId: 'owner-123',
      };

      const mockInviter = {
        id: 'owner-123',
        name: 'Owner Name',
        email: 'owner@example.com',
      };

      const mockCollaborator = {
        id: 'collab-123',
        colonyId: 'col-123',
        userId: 'user-456',
        role: 'VIEWER',
        status: 'PENDING',
      };

      jest
        .spyOn(mockDb.user, 'findUnique')
        .mockResolvedValueOnce(mockUser);
      jest
        .spyOn(mockDb.collaborator, 'create')
        .mockResolvedValue(mockCollaborator);
      jest
        .spyOn(mockDb.colony, 'findUnique')
        .mockResolvedValue(mockColony);
      jest
        .spyOn(mockDb.user, 'findUnique')
        .mockResolvedValueOnce(mockInviter);

      await service.invite(input, 'owner-123');

      expect(mockNotifications.sendEmail).toHaveBeenCalledWith(
        expect.objectContaining({
          to: 'collaborator@example.com',
          template: 'invitation_sent',
          subject: "You're invited to collaborate",
          data: expect.objectContaining({
            colonyName: 'Downtown Colony',
            role: 'VIEWER',
          }),
        }),
      );
    });
  });
});
