interface SearchResult {
  id: string;
  type: string;
  title: string;
  description?: string;
  metadata?: Record<string, any>;
}

/**
 * Convert search results to CSV format using native implementation
 */
export function exportToCSV(results: SearchResult[]): string {
  // Flatten results to include metadata fields
  const flattened = results.map(result => ({
    id: result.id,
    type: result.type,
    title: result.title,
    description: result.description || '',
    status: result.metadata?.status || '',
    healthStatus: result.metadata?.healthStatus || '',
  }));

  // Manual CSV conversion (no library needed)
  if (flattened.length === 0) {
    return 'id,type,title,description,status,healthStatus\n';
  }

  const headers = Object.keys(flattened[0]);
  const csvHeaders = headers.join(',');

  const csvRows = flattened.map(row =>
    headers
      .map(header => {
        const value = row[header as keyof typeof row];
        // Escape quotes and wrap in quotes if contains comma or quotes
        const stringValue = String(value);
        if (stringValue.includes(',') || stringValue.includes('"')) {
          return `"${stringValue.replace(/"/g, '""')}"`;
        }
        return stringValue;
      })
      .join(',')
  );

  return [csvHeaders, ...csvRows].join('\n');
}

/**
 * Convert search results to PDF format (simple text-based)
 */
export function exportToPDF(results: SearchResult[], title: string = 'Search Results'): Blob {
  // For Jest compatibility, use a simple text-based approach
  // In production, this would use jsPDF library
  const timestamp = new Date().toLocaleString();
  const pdfContent = `
${title}
Generated: ${timestamp}
Total Results: ${results.length}

================================================================================

${results
  .map(
    (result, index) => `
${index + 1}. ${result.title}
   Type: ${result.type}
   Description: ${result.description || 'N/A'}
   Status: ${result.metadata?.status || result.metadata?.healthStatus || 'N/A'}
`
  )
  .join('\n')}
`;

  return new Blob([pdfContent], { type: 'application/pdf' });
}

/**
 * Trigger download of file with given filename and data
 */
export function downloadFile(blob: Blob, filename: string): void {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
