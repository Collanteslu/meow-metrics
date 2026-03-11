import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import SearchBar from '../SearchBar';

describe('SearchBar', () => {
  it('should render search input', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    expect(screen.getByRole('textbox')).toBeInTheDocument();
  });

  it('should render search button', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    expect(screen.getByRole('button', { name: /search/i })).toBeInTheDocument();
  });

  it('should call onSearch when form submitted', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    const input = screen.getByRole('textbox') as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'fluffy' } });
    fireEvent.submit(screen.getByRole('button'));

    expect(onSearch).toHaveBeenCalledWith('fluffy');
  });

  it('should debounce search input on change', async () => {
    jest.useFakeTimers();
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    const input = screen.getByRole('textbox') as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'test' } });

    // Should not be called immediately
    expect(onSearch).not.toHaveBeenCalled();

    // Advance timers by 300ms (debounce delay)
    jest.advanceTimersByTime(300);

    // Should be called after debounce
    await waitFor(() => {
      expect(onSearch).toHaveBeenCalledWith('test');
    });

    jest.useRealTimers();
  });

  it('should accept placeholder prop', () => {
    render(
      <SearchBar
        onSearch={jest.fn()}
        placeholder="Search colonies..."
      />
    );

    expect(screen.getByPlaceholderText('Search colonies...')).toBeInTheDocument();
  });

  it('should disable button when query is empty', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    const button = screen.getByRole('button', { name: /search/i }) as HTMLButtonElement;
    expect(button).toBeDisabled();
  });

  it('should enable button when query has text', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} />);

    const input = screen.getByRole('textbox') as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'test' } });

    const button = screen.getByRole('button', { name: /search/i }) as HTMLButtonElement;
    expect(button).not.toBeDisabled();
  });

  it('should show loading state', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} loading={true} />);

    const button = screen.getByRole('button') as HTMLButtonElement;
    expect(button).toBeDisabled();
    expect(button).toHaveTextContent('Searching...');
  });

  it('should disable input when loading', () => {
    const onSearch = jest.fn();
    render(<SearchBar onSearch={onSearch} loading={true} />);

    const input = screen.getByRole('textbox') as HTMLInputElement;
    expect(input).toBeDisabled();
  });
});
