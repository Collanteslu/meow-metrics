import { Injectable, Logger, InternalServerErrorException } from '@nestjs/common';
import sgMail from '@sendgrid/mail';
import { compile } from 'handlebars';
import { DatabaseService } from '../database/database.service';
import * as fs from 'fs';
import * as path from 'path';
import {
  EmailPayload,
  EmailProvider,
  TemplateNotFoundError,
  InvalidEmailError,
  SendGridMessage,
} from './email.types';
import {
  EMAIL_CONFIG,
  EMAIL_TEMPLATES,
  EMAIL_REGEX,
} from './notifications.constants';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);
  private templates: Map<string, (data: Record<string, any>) => string> = new Map();
  private emailProvider!: EmailProvider;

  constructor(private db: DatabaseService) {
    this.initializeProvider();
    this.loadTemplates();
  }

  private initializeProvider(): void {
    const apiKey = process.env[EMAIL_CONFIG.SENDGRID_API_KEY];
    if (apiKey) {
      sgMail.setApiKey(apiKey);
      this.emailProvider = sgMail;
      this.logger.debug('SendGrid API key configured');
    } else {
      this.logger.warn(
        'SENDGRID_API_KEY not configured, using mock provider',
      );
      // Provide a mock provider for development/testing
      this.emailProvider = {
        send: async (msg: SendGridMessage) => {
          this.logger.debug(
            `Mock email sent: "${msg.subject}" to: ${msg.to}`,
          );
          return [{ statusCode: 202 }];
        },
      };
    }
  }

  private loadTemplates(): void {
    const templateDir = path.join(__dirname, 'emails/templates');

    EMAIL_TEMPLATES.forEach((name) => {
      try {
        const filePath = path.join(templateDir, `${name}.hbs`);
        if (!fs.existsSync(filePath)) {
          throw new Error(`File not found: ${filePath}`);
        }
        const content = fs.readFileSync(filePath, 'utf-8');
        this.templates.set(name, compile(content));
        this.logger.debug(`Loaded template: ${name}`);
      } catch (err) {
        this.logger.error(
          `Failed to load template ${name}: ${err instanceof Error ? err.message : String(err)}`,
        );
      }
    });
  }

  /**
   * Send an email using a template
   * @param payload - Email payload with recipient, subject, template name, and data
   * @throws InvalidEmailError - If email address is invalid
   * @throws TemplateNotFoundError - If template doesn't exist
   * @throws InternalServerErrorException - If email send fails
   * @returns Promise that resolves when email is sent and logged
   */
  async sendEmail(payload: EmailPayload): Promise<void> {
    // Validate email address
    this.validateEmail(payload.to);

    // Render template
    const html = this.renderTemplate(payload.template, payload.data);

    try {
      const fromEmail =
        process.env[EMAIL_CONFIG.SENDGRID_FROM_EMAIL] ||
        'noreply@meow-metrics.com';

      // Send email
      await this.emailProvider.send({
        to: payload.to,
        from: fromEmail,
        subject: payload.subject,
        html,
      });

      // Log successful send
      await this.db.auditLog.create({
        data: {
          action: 'CREATE',
          entityType: 'NOTIFICATION',
          entityId: `${payload.to}:${Date.now()}`,
          newValues: {
            to: payload.to,
            subject: payload.subject,
            template: payload.template,
          },
          userId: 'system', // System-initiated email send
        },
      });

      this.logger.debug(
        `Email sent to ${payload.to} using template ${payload.template}`,
      );
    } catch (error) {
      const errorMsg = `Failed to send email to ${payload.to} using template ${payload.template}: ${error instanceof Error ? error.message : String(error)}`;
      this.logger.error(errorMsg, error instanceof Error ? error.stack : '');
      throw new InternalServerErrorException(errorMsg);
    }
  }

  private validateEmail(email: string): void {
    if (!email || !EMAIL_REGEX.test(email)) {
      throw new InvalidEmailError(email);
    }
  }

  private renderTemplate(
    name: string,
    data: Record<string, any>,
  ): string {
    const template = this.templates.get(name);
    if (!template) {
      throw new TemplateNotFoundError(name);
    }
    return template(data);
  }
}
