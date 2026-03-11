'use client';
import Link from 'next/link';

export default function SettingsPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Settings</h1>

        <div className="grid gap-4 max-w-2xl">
          <Link
            href="/settings/notifications"
            className="block p-4 bg-white rounded-lg shadow hover:shadow-lg transition-shadow cursor-pointer border border-gray-200"
          >
            <h2 className="font-bold text-lg">📧 Notifications</h2>
            <p className="text-sm text-gray-600">Manage email preferences</p>
          </Link>

          <Link
            href="/settings/profile"
            className="block p-4 bg-white rounded-lg shadow hover:shadow-lg transition-shadow cursor-pointer border border-gray-200"
          >
            <h2 className="font-bold text-lg">👤 Profile</h2>
            <p className="text-sm text-gray-600">Update your information</p>
          </Link>

          <Link
            href="/settings/security"
            className="block p-4 bg-white rounded-lg shadow hover:shadow-lg transition-shadow cursor-pointer border border-gray-200"
          >
            <h2 className="font-bold text-lg">🔐 Security</h2>
            <p className="text-sm text-gray-600">Change password</p>
          </Link>
        </div>
      </div>
    </div>
  );
}
