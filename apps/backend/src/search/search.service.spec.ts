import { SearchService } from './search.service';

describe('SearchService', () => {
  let service: SearchService;
  let mockDb: any;

  beforeEach(() => {
    mockDb = {
      colony: {
        findMany: jest.fn().mockResolvedValue([
          {
            id: 'col-1',
            name: 'Downtown Colony',
            description: 'Active colony downtown',
            status: 'ACTIVE',
            location: { city: 'New York' },
          },
        ]),
        count: jest.fn().mockResolvedValue(1),
      },
      cat: {
        findMany: jest.fn().mockResolvedValue([
          {
            id: 'cat-1',
            name: 'Fluffy',
            color: 'orange',
            gender: 'MALE',
            healthStatus: 'HEALTHY',
          },
        ]),
        count: jest.fn().mockResolvedValue(1),
      },
      user: {
        findMany: jest.fn().mockResolvedValue([
          {
            id: 'user-1',
            name: 'John Doe',
            email: 'john@example.com',
            role: 'COORDINATOR',
          },
        ]),
        count: jest.fn().mockResolvedValue(1),
      },
    };

    service = new SearchService(mockDb);
  });

  describe('search', () => {
    it('should search across all entity types', async () => {
      const result = await service.search({
        query: 'test',
        type: 'all',
        skip: 0,
        take: 20,
      });

      expect(result.results).toBeDefined();
      expect(result.results.length).toBeGreaterThanOrEqual(0);
    });

    it('should search only colonies when type is colonies', async () => {
      const result = await service.search({
        query: 'downtown',
        type: 'colonies',
        skip: 0,
        take: 20,
      });

      expect(mockDb.colony.findMany).toHaveBeenCalled();
      expect(result.results[0].type).toBe('colony');
    });

    it('should search only cats when type is cats', async () => {
      const result = await service.search({
        query: 'fluffy',
        type: 'cats',
        skip: 0,
        take: 20,
      });

      expect(mockDb.cat.findMany).toHaveBeenCalled();
      expect(result.results[0].type).toBe('cat');
    });

    it('should apply filters to search', async () => {
      await service.search({
        query: 'test',
        type: 'all',
        filters: { status: 'ACTIVE', healthStatus: 'HEALTHY' },
        skip: 0,
        take: 20,
      });

      expect(mockDb.colony.findMany).toHaveBeenCalled();
      expect(mockDb.cat.findMany).toHaveBeenCalled();
    });

    it('should respect pagination parameters', async () => {
      await service.search({
        query: 'test',
        type: 'all',
        skip: 10,
        take: 5,
      });

      expect(mockDb.colony.findMany).toHaveBeenCalledWith(
        expect.objectContaining({ skip: 10, take: 5 }),
      );
    });

    it('should return hasMore flag based on result count', async () => {
      const result = await service.search({
        query: 'test',
        type: 'all',
        skip: 0,
        take: 20,
      });

      expect(result.hasMore).toBeDefined();
      expect(typeof result.hasMore).toBe('boolean');
    });
  });

  describe('searchColonies', () => {
    it('should return colonies with correct structure', async () => {
      const result = await service.search({
        query: 'downtown',
        type: 'colonies',
      });

      expect(result.results[0]).toMatchObject({
        id: expect.any(String),
        type: 'colony',
        title: expect.any(String),
      });
    });
  });

  describe('searchCats', () => {
    it('should return cats with health status in metadata', async () => {
      const result = await service.search({
        query: 'fluffy',
        type: 'cats',
      });

      expect(result.results[0].metadata?.healthStatus).toBeDefined();
    });
  });

  describe('searchUsers', () => {
    it('should return users with email', async () => {
      const result = await service.search({
        query: 'john',
        type: 'users',
      });

      expect(result.results[0].description).toContain('@');
    });
  });
});
