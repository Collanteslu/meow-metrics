'use client';

import { useState, useEffect } from 'react';
import api from '@/lib/api';

export default function ReportsPage() {
  const [stats, setStats] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [colonyId, setColonyId] = useState('');

  useEffect(() => {
    if (colonyId) {
      fetchStats();
    }
  }, [colonyId]);

  const fetchStats = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/reports/colony/${colonyId}/stats`);
      setStats(response.data);
    } catch (err) {
      console.error('Failed to load statistics');
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">📊 Reports & Analytics</h1>

        <div className="mb-6">
          <input
            type="text"
            placeholder="Enter colony ID"
            value={colonyId}
            onChange={(e) => setColonyId(e.target.value)}
            className="input w-full md:w-64"
          />
        </div>

        {loading ? (
          <p className="text-gray-500">Loading statistics...</p>
        ) : !stats ? (
          <p className="text-gray-500">No data available</p>
        ) : (
          <div className="grid md:grid-cols-2 gap-6">
            <div className="card">
              <h2 className="font-bold text-lg mb-2">Total Cats</h2>
              <p className="text-3xl font-bold text-primary">{stats.totalCats || 0}</p>
            </div>
            <div className="card">
              <h2 className="font-bold text-lg mb-2">Sterilized</h2>
              <p className="text-3xl font-bold text-secondary">
                {stats.sterilizedCount || 0}
              </p>
            </div>
            <div className="card">
              <h2 className="font-bold text-lg mb-2">Vaccination Rate</h2>
              <p className="text-3xl font-bold text-accent">
                {Math.round((stats.vaccinatedCount / (stats.totalCats || 1)) * 100)}%
              </p>
            </div>
            <div className="card">
              <h2 className="font-bold text-lg mb-2">Health Status</h2>
              <div className="space-y-2 text-sm">
                <p>Healthy: {stats.healthyCount || 0}</p>
                <p>Sick: {stats.sickCount || 0}</p>
                <p>Injured: {stats.injuredCount || 0}</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </main>
  );
}
