export const EMAIL_CONFIG = {
  SENDGRID_API_KEY: 'SENDGRID_API_KEY',
  SENDGRID_FROM_EMAIL: 'SENDGRID_FROM_EMAIL',
  APP_URL: 'APP_URL',
} as const;

export const EMAIL_TEMPLATES = [
  'welcome',
  'invitation',
  'vaccination-reminder',
  'health-alert',
  'weekly-summary',
] as const;

export const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
