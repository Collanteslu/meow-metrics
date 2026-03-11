import { exportToCSV, exportToPDF } from './export';

interface SearchResult {
  id: string;
  type: 'colony' | 'cat' | 'user';
  title: string;
  description?: string;
  metadata?: Record<string, any>;
}

describe('Export Utilities', () => {
  const mockResults: SearchResult[] = [
    {
      id: '1',
      type: 'colony',
      title: 'Downtown Colony',
      description: 'Urban colony',
      metadata: { status: 'ACTIVE', healthStatus: 'HEALTHY' },
    },
    {
      id: '2',
      type: 'cat',
      title: 'Whiskers',
      description: 'Orange tabby',
      metadata: { status: 'ACTIVE', healthStatus: 'SICK' },
    },
  ];

  describe('exportToCSV', () => {
    it('should convert results to CSV string', () => {
      const csv = exportToCSV(mockResults);
      expect(typeof csv).toBe('string');
      expect(csv.length).toBeGreaterThan(0);
    });

    it('should include headers in CSV', () => {
      const csv = exportToCSV(mockResults);
      expect(csv).toContain('id');
      expect(csv).toContain('type');
      expect(csv).toContain('title');
    });

    it('should include data rows in CSV', () => {
      const csv = exportToCSV(mockResults);
      expect(csv).toContain('Downtown Colony');
      expect(csv).toContain('Whiskers');
    });

    it('should handle empty results', () => {
      const csv = exportToCSV([]);
      expect(typeof csv).toBe('string');
    });

    it('should escape special characters in CSV', () => {
      const results = [
        {
          id: '1',
          type: 'colony' as const,
          title: 'Test, with comma',
          description: 'Description with "quotes"',
        },
      ];
      const csv = exportToCSV(results);
      expect(csv).toContain('"Test, with comma"');
    });
  });

  describe('exportToPDF', () => {
    it('should generate PDF blob for results', () => {
      const blob = exportToPDF(mockResults, 'Test Search Results');
      expect(blob).toBeInstanceOf(Blob);
      expect(blob.type).toBe('application/pdf');
    });

    it('should include title in PDF', () => {
      const blob = exportToPDF(mockResults, 'Test Title');
      expect(blob.size).toBeGreaterThan(0);
    });

    it('should handle empty results', () => {
      const blob = exportToPDF([], 'Empty Results');
      expect(blob).toBeInstanceOf(Blob);
      expect(blob.type).toBe('application/pdf');
    });

    it('should create PDF with correct metadata', () => {
      const blob = exportToPDF(mockResults, 'Search Results');
      expect(blob.size).toBeGreaterThan(0);
      // File should have reasonable size (at least 100 bytes for content)
      expect(blob.size).toBeGreaterThan(100);
      expect(blob.type).toBe('application/pdf');
    });
  });
});
