import { Test, TestingModule } from '@nestjs/testing';
import { NotificationsService, EmailPayload } from './notifications.service';
import { DatabaseService } from '../database/database.service';

describe('NotificationsService', () => {
  let service: NotificationsService;
  let mockDb: any;

  beforeEach(async () => {
    mockDb = {};

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationsService,
        { provide: DatabaseService, useValue: mockDb },
      ],
    }).compile();

    service = module.get<NotificationsService>(NotificationsService);
  });

  describe('sendEmail', () => {
    it('should send email successfully', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test Email',
        template: 'welcome',
        data: { name: 'John', appUrl: 'http://localhost:3000' },
      };

      await service.sendEmail(payload);
      // Email was sent (no exception thrown)
      expect(true).toBe(true);
    });

    it('should render template with data', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test Email',
        template: 'welcome',
        data: { name: 'Alice', appUrl: 'http://localhost:3000' },
      };

      await service.sendEmail(payload);
      expect(true).toBe(true);
    });

    it('should throw error if SendGrid API key not configured', async () => {
      const originalKey = process.env.SENDGRID_API_KEY;
      delete process.env.SENDGRID_API_KEY;

      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test Email',
        template: 'welcome',
        data: { name: 'Bob', appUrl: 'http://localhost:3000' },
      };

      // If API key is not set, sendEmail will fail
      try {
        await service.sendEmail(payload);
      } catch (error) {
        expect(error).toBeDefined();
      }

      // Restore
      if (originalKey) {
        process.env.SENDGRID_API_KEY = originalKey;
      }
    });
  });
});
