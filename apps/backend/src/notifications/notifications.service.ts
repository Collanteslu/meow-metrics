import { Injectable } from '@nestjs/common';
import sgMail from '@sendgrid/mail';
import { compile } from 'handlebars';
import { DatabaseService } from '../database/database.service';
import * as fs from 'fs';
import * as path from 'path';

export interface EmailPayload {
  to: string;
  subject: string;
  template: string;
  data: Record<string, any>;
}

@Injectable()
export class NotificationsService {
  private templates: Map<string, any> = new Map();
  private emailProvider: any;

  constructor(private db: DatabaseService) {
    if (process.env.SENDGRID_API_KEY) {
      sgMail.setApiKey(process.env.SENDGRID_API_KEY);
      this.emailProvider = sgMail;
    } else {
      // Provide a mock provider for development/testing
      this.emailProvider = {
        send: async (msg: any) => {
          console.log('Mock email sent:', msg.subject, 'to:', msg.to);
          return [{ statusCode: 202 }];
        },
      };
    }
    this.loadTemplates();
  }

  private loadTemplates(): void {
    const templateDir = path.join(__dirname, 'emails/templates');
    const templateNames = ['welcome', 'invitation', 'vaccination-reminder', 'health-alert', 'weekly-summary'];

    templateNames.forEach(name => {
      try {
        const filePath = path.join(templateDir, `${name}.hbs`);
        const content = fs.readFileSync(filePath, 'utf-8');
        this.templates.set(name, compile(content));
      } catch (err) {
        console.warn(`Failed to load template ${name}`, err);
      }
    });
  }

  async sendEmail(payload: EmailPayload): Promise<void> {
    const html = this.renderTemplate(payload.template, payload.data);

    try {
      await this.emailProvider.send({
        to: payload.to,
        from: process.env.SENDGRID_FROM_EMAIL || 'noreply@meow-metrics.com',
        subject: payload.subject,
        html,
      });

      // Note: Audit logging would be handled at service integration level
      // when this service is used by authenticated endpoints
    } catch (error) {
      console.error('Failed to send email:', error);
      throw error;
    }
  }

  private renderTemplate(name: string, data: Record<string, any>): string {
    const template = this.templates.get(name);
    if (!template) {
      console.warn(`Template ${name} not found`);
      return `<h1>Hello ${data.name || 'User'}</h1>`;
    }
    return template(data);
  }
}
