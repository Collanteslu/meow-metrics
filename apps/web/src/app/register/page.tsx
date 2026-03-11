'use client';
import { useState } from 'react';
import Link from 'next/link';

export default function RegisterPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    // API call would go here
    setLoading(false);
  };

  return (
    <main className="min-h-screen bg-gradient-to-br from-red-500 to-teal-500 flex items-center">
      <div className="w-full max-w-md bg-white rounded-lg shadow-xl p-8 mx-auto">
        <h1 className="text-3xl font-bold text-center mb-8">Create Account</h1>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label className="block text-sm font-medium mb-2">Email</label>
            <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} className="input" required />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Password</label>
            <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} className="input" required />
          </div>
          <button type="submit" className="btn btn-primary w-full" disabled={loading}>
            Create Account
          </button>
        </form>
        <p className="text-center mt-6">
          <Link href="/login" className="text-red-500 font-medium hover:underline">
            Back to login
          </Link>
        </p>
      </div>
    </main>
  );
}
