import { render, screen } from '@testing-library/react';
import SettingsPage from '../page';

describe('SettingsPage', () => {
  it('should render settings page with navigation links', () => {
    render(<SettingsPage />);

    expect(screen.getByRole('heading', { level: 1, name: /settings/i })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: /notifications/i })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: /profile/i })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: /security/i })).toBeInTheDocument();
  });

  it('should have correct href attributes for setting links', () => {
    render(<SettingsPage />);

    expect(screen.getByRole('link', { name: /notifications/i })).toHaveAttribute(
      'href',
      '/settings/notifications'
    );
    expect(screen.getByRole('link', { name: /profile/i })).toHaveAttribute(
      'href',
      '/settings/profile'
    );
  });
});
