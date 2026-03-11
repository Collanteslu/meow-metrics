export class SearchQueryDto {
  q?: string;
  type?: 'colonies' | 'cats' | 'users' | 'all';
  status?: string;
  healthStatus?: string;
  gender?: string;
  role?: string;
  skip?: number;
  take?: number;
}

export class SearchResultDto {
  id: string;
  type: 'colony' | 'cat' | 'user';
  title: string;
  description?: string;
  metadata?: Record<string, any>;
}

export class SearchResponseDto {
  results: SearchResultDto[];
  total: number;
  hasMore: boolean;
}
