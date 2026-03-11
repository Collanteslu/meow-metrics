'use client';
import { useState, useCallback, useRef } from 'react';
import SearchBar from '@/components/SearchBar';
import api from '@/lib/api';
import { exportToCSV, exportToPDF, downloadFile } from '@/lib/export';

interface SearchResult {
  id: string;
  type: 'colony' | 'cat' | 'user';
  title: string;
  description?: string;
  metadata?: Record<string, any>;
}

interface SearchResponse {
  results: SearchResult[];
  total: number;
  hasMore: boolean;
}

export default function SearchPage() {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [query, setQuery] = useState('');
  const [type, setType] = useState<'all' | 'colonies' | 'cats' | 'users'>('all');
  const [skip, setSkip] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const debounceRef = useRef<NodeJS.Timeout | null>(null);

  const handleSearch = useCallback(
    async (searchQuery: string) => {
      setQuery(searchQuery);
      setSkip(0);
      setError(null);

      if (!searchQuery.trim()) {
        setResults([]);
        return;
      }

      setLoading(true);
      try {
        const response = await api.get('/search', {
          params: {
            q: searchQuery,
            type,
            skip: 0,
            take: 20,
          },
        });

        const data: SearchResponse = response.data;
        setResults(data.results);
        setHasMore(data.hasMore);
      } catch (err) {
        setError('Failed to search. Please try again.');
        console.error('Search error:', err);
      } finally {
        setLoading(false);
      }
    },
    [type]
  );

  const handleLoadMore = async () => {
    const newSkip = skip + 20;
    setLoading(true);

    try {
      const response = await api.get('/search', {
        params: {
          q: query,
          type,
          skip: newSkip,
          take: 20,
        },
      });

      const data: SearchResponse = response.data;
      setResults(prev => [...prev, ...data.results]);
      setSkip(newSkip);
      setHasMore(data.hasMore);
    } catch (err) {
      setError('Failed to load more results.');
      console.error('Load more error:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleTypeChange = (newType: 'all' | 'colonies' | 'cats' | 'users') => {
    setType(newType);
    // Re-search with new type
    if (query.trim()) {
      handleSearch(query);
    }
  };

  const getTypeIcon = (type: string): string => {
    switch (type) {
      case 'colony':
        return '🏘️';
      case 'cat':
        return '🐱';
      case 'user':
        return '👤';
      default:
        return '🔍';
    }
  };

  const getTypeLabel = (type: string): string => {
    return type.charAt(0).toUpperCase() + type.slice(1);
  };

  const handleExportCSV = () => {
    const csv = exportToCSV(results);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    downloadFile(blob, `search-results-${Date.now()}.csv`);
  };

  const handleExportPDF = () => {
    const pdf = exportToPDF(results, `Search Results: ${query}`);
    downloadFile(pdf, `search-results-${Date.now()}.pdf`);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Search</h1>

        <div className="bg-white rounded-lg shadow p-6 mb-8">
          <SearchBar onSearch={handleSearch} loading={loading} />

          <div className="mt-4 flex gap-2 items-center">
            <label htmlFor="type-select" className="font-medium text-gray-700">
              Entity Type:
            </label>
            <select
              id="type-select"
              value={type}
              onChange={e =>
                handleTypeChange(e.target.value as 'all' | 'colonies' | 'cats' | 'users')
              }
              className="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="all">All</option>
              <option value="colonies">Colonies</option>
              <option value="cats">Cats</option>
              <option value="users">Users</option>
            </select>
          </div>
        </div>

        {error && (
          <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-800">
            {error}
          </div>
        )}

        {results.length === 0 && query && !loading && (
          <div className="text-center py-12 text-gray-500">
            <p className="text-lg">No results found for "{query}"</p>
          </div>
        )}

        {results.length > 0 && (
          <div className="mb-6 bg-white rounded-lg shadow p-4 flex justify-between items-center">
            <div className="text-sm text-gray-600">
              Showing <strong>{results.length}</strong> results
            </div>
            <div className="flex gap-2">
              <button
                onClick={handleExportCSV}
                className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
              >
                📊 Export CSV
              </button>
              <button
                onClick={handleExportPDF}
                className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors flex items-center gap-2"
              >
                📄 Export PDF
              </button>
            </div>
          </div>
        )}

        <div className="grid gap-4 mb-8">
          {results.map(result => (
            <div
              key={result.id}
              className="bg-white rounded-lg shadow p-4 hover:shadow-lg transition-shadow"
            >
              <div className="flex items-start gap-3">
                <span className="text-2xl flex-shrink-0">{getTypeIcon(result.type)}</span>
                <div className="flex-1">
                  <h2 className="font-bold text-lg">{result.title}</h2>
                  {result.description && (
                    <p className="text-sm text-gray-600 mt-1">{result.description}</p>
                  )}
                  <div className="mt-3 flex flex-wrap gap-2">
                    <span className="px-2 py-1 text-xs bg-gray-100 text-gray-800 rounded">
                      {getTypeLabel(result.type)}
                    </span>
                    {result.metadata?.status && (
                      <span className="px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded">
                        {result.metadata.status}
                      </span>
                    )}
                    {result.metadata?.healthStatus && (
                      <span className="px-2 py-1 text-xs bg-green-100 text-green-800 rounded">
                        {result.metadata.healthStatus}
                      </span>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {hasMore && results.length > 0 && (
          <div className="text-center mb-8">
            <button
              onClick={handleLoadMore}
              disabled={loading}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Loading...' : 'Load More'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
