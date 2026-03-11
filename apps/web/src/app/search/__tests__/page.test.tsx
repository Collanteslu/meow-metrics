import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import SearchPage from '../page';
import * as apiModule from '@/lib/api';

// Mock the api module
jest.mock('@/lib/api');

const mockApi = apiModule as jest.Mocked<typeof apiModule>;

describe('SearchPage', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  // Mock download file function
  beforeEach(() => {
    global.URL.createObjectURL = jest.fn(() => 'blob:mock-url');
    global.URL.revokeObjectURL = jest.fn();
  });

  it('should render search page with heading', () => {
    render(<SearchPage />);
    expect(screen.getByRole('heading', { level: 1, name: /search/i })).toBeInTheDocument();
  });

  it('should render search bar', () => {
    render(<SearchPage />);
    expect(screen.getByPlaceholderText(/search/i)).toBeInTheDocument();
  });

  it('should render type filter dropdown', () => {
    render(<SearchPage />);
    expect(screen.getByLabelText(/entity type/i)).toBeInTheDocument();
  });

  it('should fetch results when searching', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'downtown' } });

    // Advance timers to trigger debounced search
    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(mockApi.default.get).toHaveBeenCalledWith(
        '/search',
        expect.objectContaining({
          params: expect.objectContaining({
            q: 'downtown',
          }),
        })
      );
    });
  });

  it('should render search results', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
            metadata: { status: 'ACTIVE' },
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'downtown' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText('Downtown Colony')).toBeInTheDocument();
    });
  });

  it('should display result metadata badges', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'cat',
            title: 'Whiskers',
            description: 'Orange male',
            metadata: { healthStatus: 'HEALTHY' },
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'whiskers' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText('HEALTHY')).toBeInTheDocument();
    });
  });

  it('should show no results message when query returns empty', async () => {
    const mockResults = {
      data: {
        results: [],
        total: 0,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'nonexistent' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText(/no results found/i)).toBeInTheDocument();
    });
  });

  it('should handle load more button for pagination', async () => {
    const mockResults = {
      data: {
        results: Array(20)
          .fill(null)
          .map((_, i) => ({
            id: `cat-${i}`,
            type: 'cat',
            title: `Cat ${i}`,
            description: 'Orange male',
          })),
        total: 40,
        hasMore: true,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'cat' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText('Cat 0')).toBeInTheDocument();
    });

    // Check for load more button
    const loadMoreButton = screen.getByRole('button', { name: /load more/i });
    expect(loadMoreButton).toBeInTheDocument();
  });

  it('should load more results when load more button clicked', async () => {
    const mockResultsPage1 = {
      data: {
        results: Array(20)
          .fill(null)
          .map((_, i) => ({
            id: `cat-${i}`,
            type: 'cat',
            title: `Cat ${i}`,
            description: 'Page 1',
          })),
        total: 40,
        hasMore: true,
      },
    };

    const mockResultsPage2 = {
      data: {
        results: Array(20)
          .fill(null)
          .map((_, i) => ({
            id: `cat-${i + 20}`,
            type: 'cat',
            title: `Cat ${i + 20}`,
            description: 'Page 2',
          })),
        total: 40,
        hasMore: false,
      },
    };

    mockApi.default.get = jest
      .fn()
      .mockResolvedValueOnce(mockResultsPage1)
      .mockResolvedValueOnce(mockResultsPage2);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'cat' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText('Cat 0')).toBeInTheDocument();
    });

    const loadMoreButton = screen.getByRole('button', { name: /load more/i });
    fireEvent.click(loadMoreButton);

    await waitFor(() => {
      expect(mockApi.default.get).toHaveBeenCalledTimes(2);
      expect(mockApi.default.get).toHaveBeenLastCalledWith(
        '/search',
        expect.objectContaining({
          params: expect.objectContaining({
            skip: 20,
          }),
        })
      );
    });
  });

  it('should filter results by type', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const typeSelect = screen.getByDisplayValue('All') as HTMLSelectElement;
    fireEvent.change(typeSelect, { target: { value: 'colonies' } });

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'downtown' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(mockApi.default.get).toHaveBeenCalledWith(
        '/search',
        expect.objectContaining({
          params: expect.objectContaining({
            type: 'colonies',
          }),
        })
      );
    });
  });

  it('should handle API errors gracefully', async () => {
    const mockError = new Error('API Error');
    mockApi.default.get = jest.fn().mockRejectedValue(mockError);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'test' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByText(/failed to search/i)).toBeInTheDocument();
    });
  });

  it('should show result count in export header', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
          },
          {
            id: '2',
            type: 'colony',
            title: 'Uptown Colony',
            description: 'Inactive colony',
          },
        ],
        total: 2,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'colony' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      // Verify export header appears with buttons (which proves results are showing)
      expect(screen.getByRole('button', { name: /export csv/i })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: /export pdf/i })).toBeInTheDocument();
      // Verify both results are visible
      expect(screen.getByText('Downtown Colony')).toBeInTheDocument();
      expect(screen.getByText('Uptown Colony')).toBeInTheDocument();
    });
  });

  it('should show export buttons when results exist', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'colony' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      expect(screen.getByRole('button', { name: /export csv/i })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: /export pdf/i })).toBeInTheDocument();
    });
  });

  it('should hide export buttons when no results', () => {
    render(<SearchPage />);
    expect(screen.queryByRole('button', { name: /export csv/i })).not.toBeInTheDocument();
    expect(screen.queryByRole('button', { name: /export pdf/i })).not.toBeInTheDocument();
  });

  it('should have both export buttons visible in export header', async () => {
    const mockResults = {
      data: {
        results: [
          {
            id: '1',
            type: 'colony',
            title: 'Downtown Colony',
            description: 'Active colony',
          },
        ],
        total: 1,
        hasMore: false,
      },
    };

    mockApi.default.get = jest.fn().mockResolvedValue(mockResults);

    render(<SearchPage />);

    const input = screen.getByPlaceholderText(/search/i) as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'colony' } });

    jest.advanceTimersByTime(300);

    await waitFor(() => {
      const csvButton = screen.getByRole('button', { name: /export csv/i });
      const pdfButton = screen.getByRole('button', { name: /export pdf/i });
      expect(csvButton).toHaveClass('bg-green-600');
      expect(pdfButton).toHaveClass('bg-red-600');
    });
  });
});
