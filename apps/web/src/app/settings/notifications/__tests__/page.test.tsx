import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import NotificationsSettingsPage from '../page';
import * as api from '@/lib/api';

jest.mock('@/lib/api');

// Suppress act warnings in tests
const originalError = console.error;
beforeAll(() => {
  console.error = (...args: any[]) => {
    if (
      typeof args[0] === 'string' &&
      args[0].includes('An update to NotificationsSettingsPage inside a test was not wrapped in act')
    ) {
      return;
    }
    originalError.call(console, ...args);
  };
});

afterAll(() => {
  console.error = originalError;
});

describe('NotificationsSettingsPage', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should render notification preferences form', () => {
    (api.default.get as jest.Mock).mockResolvedValue({
      data: {
        emailOnWelcome: true,
        emailOnInvitation: true,
        emailOnVaccinationDue: true,
        emailOnHealthAlert: true,
        emailWeeklySummary: false,
      },
    });

    render(<NotificationsSettingsPage />);

    expect(screen.getByRole('heading', { name: /notification preferences/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /save preferences/i })).toBeInTheDocument();
  });

  it('should load preferences on mount', async () => {
    const mockPreferences = {
      emailOnWelcome: true,
      emailOnInvitation: true,
      emailOnVaccinationDue: true,
      emailOnHealthAlert: true,
      emailWeeklySummary: false,
    };

    (api.default.get as jest.Mock).mockResolvedValue({
      data: mockPreferences,
    });

    render(<NotificationsSettingsPage />);

    await waitFor(() => {
      expect(api.default.get).toHaveBeenCalledWith('/users/me/notification-preferences');
    });
  });

  it('should toggle preferences on checkbox click', async () => {
    const mockPreferences = {
      emailOnWelcome: true,
      emailOnInvitation: false,
      emailOnVaccinationDue: true,
      emailOnHealthAlert: true,
      emailWeeklySummary: false,
    };

    (api.default.get as jest.Mock).mockResolvedValue({
      data: mockPreferences,
    });

    render(<NotificationsSettingsPage />);

    await waitFor(() => {
      expect(api.default.get).toHaveBeenCalled();
    });

    const checkboxes = screen.getAllByRole('checkbox');
    expect(checkboxes.length).toBeGreaterThan(0);

    const firstCheckbox = checkboxes[0] as HTMLInputElement;
    const initialState = firstCheckbox.checked;

    fireEvent.click(firstCheckbox);

    await waitFor(() => {
      expect(firstCheckbox.checked).toBe(!initialState);
    });
  });

  it('should save preferences on save button click', async () => {
    const mockPreferences = {
      emailOnWelcome: true,
      emailOnInvitation: false,
      emailOnVaccinationDue: true,
      emailOnHealthAlert: true,
      emailWeeklySummary: false,
    };

    (api.default.get as jest.Mock).mockResolvedValue({
      data: mockPreferences,
    });

    (api.default.patch as jest.Mock).mockResolvedValue({});

    render(<NotificationsSettingsPage />);

    await waitFor(() => {
      expect(api.default.get).toHaveBeenCalled();
    });

    const saveButton = screen.getByRole('button', { name: /save preferences/i });
    fireEvent.click(saveButton);

    await waitFor(() => {
      expect(api.default.patch).toHaveBeenCalledWith(
        '/users/me/notification-preferences',
        expect.any(Object)
      );
    });
  });

  it('should display success message after saving', async () => {
    const mockPreferences = {
      emailOnWelcome: true,
      emailOnInvitation: true,
      emailOnVaccinationDue: true,
      emailOnHealthAlert: true,
      emailWeeklySummary: false,
    };

    (api.default.get as jest.Mock).mockResolvedValue({
      data: mockPreferences,
    });

    (api.default.patch as jest.Mock).mockResolvedValue({});

    render(<NotificationsSettingsPage />);

    await waitFor(() => {
      expect(api.default.get).toHaveBeenCalled();
    });

    const saveButton = screen.getByRole('button', { name: /save preferences/i });
    fireEvent.click(saveButton);

    await waitFor(() => {
      expect(screen.getByText(/preferences saved successfully/i)).toBeInTheDocument();
    });
  });
});
