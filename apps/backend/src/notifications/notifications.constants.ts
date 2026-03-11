export const NOTIFICATION_TYPES = {
  WELCOME: 'welcome',
  INVITATION_SENT: 'invitation_sent',
  INVITATION_ACCEPTED: 'invitation_accepted',
  VACCINATION_DUE: 'vaccination_due',
  HEALTH_ALERT: 'health_alert',
  WEEKLY_SUMMARY: 'weekly_summary',
} as const;

export const NOTIFICATION_SUBJECTS = {
  [NOTIFICATION_TYPES.WELCOME]: 'Welcome to Meow Metrics!',
  [NOTIFICATION_TYPES.INVITATION_SENT]: "You're invited to collaborate",
  [NOTIFICATION_TYPES.INVITATION_ACCEPTED]: 'Invitation accepted',
  [NOTIFICATION_TYPES.VACCINATION_DUE]: 'Vaccination reminder',
  [NOTIFICATION_TYPES.HEALTH_ALERT]: 'Health alert for your cat',
  [NOTIFICATION_TYPES.WEEKLY_SUMMARY]: 'Weekly summary report',
};

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
