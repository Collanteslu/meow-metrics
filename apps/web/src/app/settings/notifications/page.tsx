'use client';
import { useState, useEffect } from 'react';
import api from '@/lib/api';

interface NotificationPreferences {
  emailOnWelcome: boolean;
  emailOnInvitation: boolean;
  emailOnVaccinationDue: boolean;
  emailOnHealthAlert: boolean;
  emailWeeklySummary: boolean;
}

export default function NotificationsSettingsPage() {
  const [preferences, setPreferences] = useState<NotificationPreferences>({
    emailOnWelcome: true,
    emailOnInvitation: true,
    emailOnVaccinationDue: true,
    emailOnHealthAlert: true,
    emailWeeklySummary: true,
  });
  const [loading, setLoading] = useState(false);
  const [saveStatus, setSaveStatus] = useState<'idle' | 'saving' | 'success' | 'error'>('idle');

  useEffect(() => {
    let isMounted = true;

    const fetchPreferences = async () => {
      try {
        const response = await api.get('/users/me/notification-preferences');
        if (isMounted) {
          setPreferences(response.data);
        }
      } catch (err) {
        if (isMounted) {
          console.error('Failed to fetch preferences:', err);
          setSaveStatus('error');
        }
      }
    };

    fetchPreferences();

    return () => {
      isMounted = false;
    };
  }, []);

  const handleToggle = (key: keyof NotificationPreferences) => {
    setPreferences((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  const handleSave = async () => {
    setLoading(true);
    setSaveStatus('saving');
    try {
      await api.patch('/users/me/notification-preferences', preferences);
      setSaveStatus('success');
      setTimeout(() => setSaveStatus('idle'), 3000);
    } catch (err) {
      console.error('Failed to save preferences:', err);
      setSaveStatus('error');
    } finally {
      setLoading(false);
    }
  };

  const preferenceLabels: Record<keyof NotificationPreferences, string> = {
    emailOnWelcome: 'Welcome Email',
    emailOnInvitation: 'Invitation Emails',
    emailOnVaccinationDue: 'Vaccination Reminders',
    emailOnHealthAlert: 'Health Alerts',
    emailWeeklySummary: 'Weekly Summary',
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8 max-w-2xl">
        <h1 className="text-3xl font-bold mb-8">Notification Preferences</h1>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="space-y-4 mb-6">
            {Object.entries(preferences).map(([key, value]) => (
              <label
                key={key}
                className="flex items-center cursor-pointer hover:bg-gray-50 p-2 rounded"
              >
                <input
                  type="checkbox"
                  checked={value}
                  onChange={() => handleToggle(key as keyof NotificationPreferences)}
                  className="w-4 h-4 rounded border-gray-300 text-blue-600 cursor-pointer"
                  aria-label={preferenceLabels[key as keyof NotificationPreferences]}
                />
                <span className="ml-3 text-gray-700 font-medium">
                  {preferenceLabels[key as keyof NotificationPreferences]}
                </span>
              </label>
            ))}
          </div>

          {saveStatus === 'success' && (
            <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded text-green-800">
              ✓ Preferences saved successfully!
            </div>
          )}

          {saveStatus === 'error' && (
            <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded text-red-800">
              ✗ Failed to save preferences. Please try again.
            </div>
          )}

          <button
            onClick={handleSave}
            disabled={loading}
            className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            {loading ? 'Saving...' : 'Save Preferences'}
          </button>
        </div>

        <div className="mt-6 text-sm text-gray-600">
          <p>
            💡 Manage which emails you receive from Meow Metrics. You&apos;ll always receive
            critical notifications about your colonies and cats.
          </p>
        </div>
      </div>
    </div>
  );
}
