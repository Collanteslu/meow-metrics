import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Meow Metrics - Urban Cat Colony Management',
  description: 'Manage urban cat colonies with health tracking and analytics',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-gray-50">{children}</body>
    </html>
  );
}
