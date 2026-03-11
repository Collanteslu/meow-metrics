'use client';

import { useState, useEffect } from 'react';
import api from '@/lib/api';

export default function HealthPage() {
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [colonyId, setColonyId] = useState('');

  useEffect(() => {
    if (colonyId) {
      fetchRecords();
    }
  }, [colonyId]);

  const fetchRecords = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/health/by-colony/${colonyId}`);
      setRecords(response.data);
    } catch (err) {
      console.error('Failed to load health records');
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">💊 Health Records</h1>

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
          <p className="text-gray-500">Loading health records...</p>
        ) : records.length === 0 ? (
          <p className="text-gray-500">No health records found</p>
        ) : (
          <div className="space-y-4">
            {records.map((record: any) => (
              <div key={record.id} className="card">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="font-bold">{record.recordType}</h3>
                    <p className="text-gray-600">{record.description}</p>
                  </div>
                  <span className="text-sm text-gray-500">
                    {new Date(record.recordedAt).toLocaleDateString()}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
