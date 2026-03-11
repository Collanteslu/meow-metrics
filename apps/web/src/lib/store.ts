import { create } from 'zustand';

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'ADMIN' | 'COORDINATOR' | 'VOLUNTEER';
}

export interface AuthStore {
  user: User | null;
  isLoading: boolean;
  error: string | null;
  setUser: (user: User | null) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
}

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  isLoading: false,
  error: null,
  setUser: (user) => set({ user }),
  setLoading: (loading) => set({ isLoading: loading }),
  setError: (error) => set({ error }),
}));

export interface Colony {
  id: string;
  name: string;
  description?: string;
  estimatedPopulation: number;
  status: 'ACTIVE' | 'INACTIVE';
  location: {
    latitude: number;
    longitude: number;
    address: string;
    city: string;
  };
}

export interface ColoniesStore {
  colonies: Colony[];
  selectedColony: Colony | null;
  isLoading: boolean;
  setColonies: (colonies: Colony[]) => void;
  setSelectedColony: (colony: Colony | null) => void;
  setLoading: (loading: boolean) => void;
}

export const useColoniesStore = create<ColoniesStore>((set) => ({
  colonies: [],
  selectedColony: null,
  isLoading: false,
  setColonies: (colonies) => set({ colonies }),
  setSelectedColony: (colony) => set({ selectedColony: colony }),
  setLoading: (loading) => set({ isLoading: loading }),
}));
