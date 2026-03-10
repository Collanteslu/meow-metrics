# Meow Metrics: Web Frontend Implementation Plan (Next.js 16)

> **Execution:** Use subagent-driven-development. Can start in parallel with backend using mock API.

**Goal:** Build fully functional Next.js 16 web app with authentication, colony management, and reporting UI.

**Architecture:** App router with layout composition, API client wrapper, Zustand for state, Tailwind for styling.

**Tech Stack:** Next.js 16, TypeScript, Tailwind CSS, Zustand, Zod, Leaflet (maps)

**Estimated time:** 5-7 days (can develop in parallel with backend)

---

## Part 1: Project Setup & Layout (1 day)

### Structure
```
app/
├── (auth)/
│   ├── login/page.tsx
│   ├── register/page.tsx
│   └── layout.tsx
├── (dashboard)/
│   ├── layout.tsx
│   └── page.tsx
├── layout.tsx
└── page.tsx (landing)

lib/
├── api/
├── hooks/
├── schemas/
├── store/
└── utils/

components/
├── auth/
├── navigation/
├── common/
└── shared/
```

### Key Tasks
1. **Next.js app setup** - Initialize with Tailwind, TypeScript
2. **Layout hierarchy** - Root, auth layout, dashboard layout
3. **Navigation component** - Header, sidebar with role-based menus
4. **Styling system** - Tailwind configuration, utility classes
5. **Mock API client** - Temporary fetch wrapper for testing UI without backend

---

## Part 2: Authentication Pages (1 day)

### Pages
- **Login** - Email/password form with validation
- **Register** - Create account with role selection
- **Forgot Password** - Password reset flow

### Key Tasks
1. **Form components** - Reusable input, button, error message components
2. **Zod validation** - Client-side form validation
3. **API integration** - Call auth endpoints (or mock)
4. **Session persistence** - JWT in cookies, auto-refresh
5. **Route protection** - Middleware to redirect unauthenticated users

---

## Part 3: Dashboard & Core UI (2 days)

### Pages
- **Dashboard** - Overview with stats, recent activity
- **Colonies List** - Searchable, filterable table
- **Colony Detail** - Map, info, tabs for cats/health/CER
- **Settings** - User profile, preferences

### Key Features
1. **Maps** - Leaflet integration, show colony locations
2. **Data tables** - Sortable, filterable, paginated
3. **Stats cards** - Population, sterilized count, city totals
4. **Modals** - Create/edit colony, invite collaborator
5. **Responsive design** - Mobile-friendly layout

---

## Part 4: Cats & Health Management (1.5 days)

### Pages
- **Cats List** - Per colony, with photo gallery
- **Cat Detail** - Individual health history
- **Add Cat** - Form with photo upload
- **CER Tracking** - Timeline of sterilizations

### Key Tasks
1. **Photo display** - Gallery with lightbox
2. **Form handling** - Multi-step forms, dynamic fields
3. **Date pickers** - Select appointment dates
4. **Status indicators** - Color-coded health/sterilization status
5. **Batch actions** - Mark multiple cats for sterilization

---

## Part 5: Collaboration & Reports (1.5 days)

### Pages
- **Collaborators** - Manage access to colonies
- **Invitations** - Send collaboration invites
- **Reports** - Charts, statistics, export options
- **Admin Dashboard** - (For municipality admins) city-wide stats

### Key Features
1. **Collaboration UI** - Add/remove collaborators, role selection
2. **Charts** - Use Recharts or Chart.js for graphs
3. **Export** - Button to generate PDF/Excel (backend processes)
4. **Permissions UI** - Show what current user can do
5. **Audit trail** - Recent activity log

---

## Important Implementation Details

### API Client
```typescript
// lib/api/client.ts
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  withCredentials: true,
});

// Auto-refresh token on 401
apiClient.interceptors.response.use(...);
```

### Zustand Store
```typescript
// lib/store.ts
const useAppStore = create((set) => ({
  user: null,
  colonies: [],
  setUser: (user) => set({ user }),
  // ...
}));
```

### Custom Hooks
```typescript
// lib/hooks/useColonies.ts
export const useColonies = (filter?: ColonyFilter) => {
  const [colonies, setColonies] = useState([]);
  useEffect(() => {
    apiClient.get('/colonies', { params: filter }).then(setColonies);
  }, [filter]);
  return colonies;
};
```

### Protected Routes
```typescript
// middleware.ts - Protect dashboard routes
export function middleware(request) {
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    // Check auth, redirect if needed
  }
}
```

---

## Testing Strategy

- **Unit tests** - Component snapshot tests
- **Integration tests** - API client + hooks
- **E2E tests** - Critical user flows (Playwright)

---

## Deliverables

- ✅ Fully functional web app
- ✅ All pages responsive
- ✅ Authentication working
- ✅ Can view/manage colonies
- ✅ Can manage cats and health records
- ✅ Collaboration UI functional
- ✅ Reports display data
- ✅ Tests passing

---

**Web plan complete. Ready for production deployment.**
