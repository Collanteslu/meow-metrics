export interface EmailPayload {
  to: string;
  subject: string;
  template: string;
  data: Record<string, string | number | boolean>;
}

export interface SendGridMessage {
  to: string;
  from: string;
  subject: string;
  html: string;
}

export interface EmailProvider {
  send(message: SendGridMessage): Promise<any>;
}

export class TemplateNotFoundError extends Error {
  constructor(template: string) {
    super(`Email template not found: ${template}`);
    this.name = 'TemplateNotFoundError';
  }
}

export class InvalidEmailError extends Error {
  constructor(email: string) {
    super(`Invalid email address: ${email}`);
    this.name = 'InvalidEmailError';
  }
}
