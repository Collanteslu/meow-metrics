'use client';

import { useState, useEffect } from 'react';
import api from '@/lib/api';

export default function CollaborationPage() {
  const [collaborators, setCollaborators] = useState([]);
  const [loading, setLoading] = useState(true);
  const [colonyId, setColonyId] = useState('');

  useEffect(() => {
    if (colonyId) {
      fetchCollaborators();
    }
  }, [colonyId]);

  const fetchCollaborators = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/collaborations/colony/${colonyId}`);
      setCollaborators(response.data);
    } catch (err) {
      console.error('Failed to load collaborators');
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">👥 Collaboration</h1>

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
          <p className="text-gray-500">Loading collaborators...</p>
        ) : collaborators.length === 0 ? (
          <p className="text-gray-500">No collaborators found</p>
        ) : (
          <div className="grid gap-4">
            {collaborators.map((collab: any) => (
              <div key={collab.id} className="card">
                <div className="flex justify-between items-center">
                  <div>
                    <h3 className="font-bold">{collab.user?.name || 'Unknown'}</h3>
                    <p className="text-sm text-gray-600">{collab.user?.email}</p>
                  </div>
                  <div className="text-right">
                    <span className="inline-block bg-blue-100 text-blue-800 px-3 py-1 rounded text-sm font-medium">
                      {collab.role}
                    </span>
                    <p className="text-xs text-gray-500 mt-1">
                      Status: {collab.status}
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
