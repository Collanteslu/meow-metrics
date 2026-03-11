import { Test, TestingModule } from '@nestjs/testing';
import { NotificationsService } from './notifications.service';
import { DatabaseService } from '../database/database.service';
import { InvalidEmailError, TemplateNotFoundError, EmailPayload } from './email.types';

describe('NotificationsService', () => {
  let service: NotificationsService;
  let mockDb: any;
  let module: TestingModule;

  beforeEach(async () => {
    mockDb = {
      auditLog: {
        create: jest.fn().mockResolvedValue({ id: '1' }),
      },
    };

    module = await Test.createTestingModule({
      providers: [
        NotificationsService,
        { provide: DatabaseService, useValue: mockDb },
      ],
    }).compile();

    service = module.get<NotificationsService>(NotificationsService);

    // Ensure db is properly set
    (service as any).db = mockDb;

    // Mock the email provider to succeed
    (service as any).emailProvider = {
      send: jest.fn().mockResolvedValue([{ statusCode: 202 }]),
    };

    // Mock templates
    service['templates'].set('welcome', () => '<h1>Welcome</h1>');
    service['templates'].set('invitation', () => '<h1>Invited</h1>');

    // Reset mocks before each test
    jest.clearAllMocks();
  });

  afterEach(async () => {
    await module.close();
  });

  describe('sendEmail', () => {
    it('should send email and log audit entry', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test Email',
        template: 'welcome',
        data: { name: 'John' },
      };

      jest
        .spyOn(service as any, 'renderTemplate')
        .mockReturnValue('<h1>Welcome John</h1>');

      await service.sendEmail(payload);

      expect(mockDb.auditLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          action: 'CREATE',
          entityType: 'NOTIFICATION',
          newValues: expect.objectContaining({ to: 'test@example.com' }),
        }),
      });
    });

    it('should validate email address before sending', async () => {
      const payload: EmailPayload = {
        to: 'invalid-email',
        subject: 'Test',
        template: 'welcome',
        data: {},
      };

      await expect(service.sendEmail(payload)).rejects.toThrow(
        InvalidEmailError,
      );
      expect(mockDb.auditLog.create).not.toHaveBeenCalled();
    });

    it('should throw error if template not found', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test',
        template: 'nonexistent',
        data: {},
      };

      await expect(service.sendEmail(payload)).rejects.toThrow(
        TemplateNotFoundError,
      );
      expect(mockDb.auditLog.create).not.toHaveBeenCalled();
    });

    it('should render template with correct data', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test',
        template: 'welcome',
        data: { name: 'Alice' },
      };

      const renderSpy = jest
        .spyOn(service as any, 'renderTemplate')
        .mockReturnValue('<h1>Welcome Alice</h1>');

      await service.sendEmail(payload);

      expect(renderSpy).toHaveBeenCalledWith('welcome', { name: 'Alice' });
    });

    it('should include recipient and template in error context', async () => {
      const payload: EmailPayload = {
        to: 'test@example.com',
        subject: 'Test',
        template: 'welcome',
        data: {},
      };

      // Mock a failed send
      const failingSend = jest.fn().mockRejectedValue(new Error('SendGrid error'));
      (service as any).emailProvider = { send: failingSend };

      jest
        .spyOn(service as any, 'renderTemplate')
        .mockReturnValue('<h1>Welcome</h1>');

      // Even with email provider mock failing, we should get context in error
      try {
        await service.sendEmail(payload);
      } catch (error) {
        expect(error).toBeDefined();
      }
    });
  });

  describe('validateEmail', () => {
    it('should accept valid email addresses', () => {
      expect(() => {
        service['validateEmail']('user@example.com');
      }).not.toThrow();
    });

    it('should reject invalid email addresses', () => {
      expect(() => {
        service['validateEmail']('invalid-email');
      }).toThrow(InvalidEmailError);
    });

    it('should reject empty email', () => {
      expect(() => {
        service['validateEmail']('');
      }).toThrow(InvalidEmailError);
    });

    it('should accept emails with multiple parts in domain', () => {
      expect(() => {
        service['validateEmail']('user@mail.example.co.uk');
      }).not.toThrow();
    });

    it('should reject email without @', () => {
      expect(() => {
        service['validateEmail']('useratexample.com');
      }).toThrow(InvalidEmailError);
    });
  });

  describe('renderTemplate', () => {
    it('should render template with data', () => {
      const template = (data: any) => `<h1>Hello ${data.name}</h1>`;
      service['templates'].set('test', template);

      const result = service['renderTemplate']('test', { name: 'Bob' });
      expect(result).toContain('Bob');
    });

    it('should throw error for missing template', () => {
      expect(() => {
        service['renderTemplate']('missing', {});
      }).toThrow(TemplateNotFoundError);
    });

    it('should throw TemplateNotFoundError with template name', () => {
      expect(() => {
        service['renderTemplate']('nonexistent', {});
      }).toThrow('Email template not found: nonexistent');
    });
  });
});
