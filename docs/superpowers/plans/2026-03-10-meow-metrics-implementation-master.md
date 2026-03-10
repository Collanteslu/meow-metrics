# Meow Metrics - Master Implementation Plan

> **For agentic workers:** Use superpowers:subagent-driven-development to execute sub-plans in parallel. Each sub-plan is independent and can be worked simultaneously.

**Goal:** Build a complete collaborative app for managing urban cat colonies with web and mobile clients, backend API, and PostgreSQL database.

**Architecture:** Monolithic modular backend (NestJS) serving two clients (Next.js web + Flutter mobile). PostgreSQL as single source of truth. Zod for validation everywhere.

**Tech Stack:**
- Backend: NestJS 11, Prisma ORM, PostgreSQL, Zod
- Frontend: Next.js 16, TypeScript, Zustand, Tailwind CSS
- Mobile: Flutter, Riverpod, SQLite (local)
- DevOps: Docker, GitHub Actions, automated migrations

---

## Project Structure

```
meow-metrics/
├── apps/
│   ├── backend/              # NestJS 11 API
│   │   ├── src/
│   │   ├── test/
│   │   ├── prisma/           # Prisma schema
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── web/                  # Next.js 16 web app
│   │   ├── app/
│   │   ├── components/
│   │   ├── lib/
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── mobile/               # Flutter app
│       ├── lib/
│       ├── test/
│       ├── pubspec.yaml
│       └── android/ios/
├── docs/
│   ├── superpowers/specs/
│   │   └── 2026-03-10-meow-metrics-app-design.md
│   └── superpowers/plans/
│       ├── 2026-03-10-meow-metrics-implementation-master.md (this file)
│       ├── 2026-03-10-meow-metrics-backend.md
│       ├── 2026-03-10-meow-metrics-web.md
│       ├── 2026-03-10-meow-metrics-mobile.md
│       └── 2026-03-10-meow-metrics-database.md
├── docker-compose.yml
├── .github/workflows/        # CI/CD
├── .gitignore
└── README.md
```

---

## Implementation Order & Dependencies

### Phase 1: Foundation (Must complete first)
**These are blockers for everything else:**

1. **Database Schema** (`2026-03-10-meow-metrics-database.md`)
   - PostgreSQL database
   - Prisma schema definition
   - Migrations system
   - Seed data for testing
   - **Duration:** ~2-3 days
   - **Blocks:** Backend and any data-dependent work

2. **Backend Core** (`2026-03-10-meow-metrics-backend.md` - Part 1)
   - Project scaffolding
   - Docker setup
   - Database connection
   - Authentication module (login/register)
   - User and role management
   - **Duration:** ~3-4 days
   - **Blocks:** All API endpoints

### Phase 2: Parallel Development (Can happen simultaneously)
**These don't depend on each other:**

3. **Backend Features** (`2026-03-10-meow-metrics-backend.md` - Part 2-5)
   - Colonies CRUD
   - Cats management
   - Sterilization (CER)
   - Health records
   - Collaboration & permissions
   - Reports & analytics
   - **Duration:** ~5-7 days
   - **Blocks:** Nothing (clients wait for complete API)

4. **Frontend Web** (`2026-03-10-meow-metrics-web.md`)
   - Project setup
   - Layout & navigation
   - Auth pages
   - Dashboard
   - Colonies management UI
   - Cats UI
   - Reports UI
   - **Duration:** ~5-7 days
   - **Dependencies:** Backend API endpoints (can mock while waiting)

5. **Mobile App** (`2026-03-10-meow-metrics-mobile.md`)
   - Project setup
   - Auth screens
   - Colonies list with map
   - Cats management
   - Offline sync
   - **Duration:** ~5-7 days
   - **Dependencies:** Backend API endpoints (can mock while waiting)

### Phase 3: Integration & Polish
6. **Testing & QA**
   - End-to-end tests
   - Manual testing
   - Bug fixes
   - Performance optimization

7. **Deployment**
   - Production database setup
   - CI/CD pipeline
   - Monitoring & logging
   - Security hardening

---

## Sub-Plans Overview

### Plan 1: Database (2-3 days)
**Deliverable:** PostgreSQL with Prisma schema, migrations ready
**Key files:**
- `apps/backend/prisma/schema.prisma`
- `apps/backend/prisma/migrations/*`

### Plan 2: Backend (10-12 days total)
**Deliverable:** Complete NestJS API with all endpoints, tests passing
**Key files:**
- `apps/backend/src/auth/`
- `apps/backend/src/users/`
- `apps/backend/src/colonies/`
- `apps/backend/src/cats/`
- etc.

### Plan 3: Web Frontend (5-7 days)
**Deliverable:** Fully functional Next.js 16 web app
**Key files:**
- `apps/web/app/*`
- `apps/web/components/*`
- `apps/web/lib/*`

### Plan 4: Mobile (5-7 days)
**Deliverable:** Fully functional Flutter app with offline support
**Key files:**
- `lib/features/*`
- `lib/models/*`
- `lib/services/*`

---

## Execution Strategy

### For Sequential Execution (Single developer):
1. Complete Plan 1 (Database) - Foundation
2. Complete Plan 2 (Backend) - API layer
3. Complete Plans 3 & 4 in sequence (Web, then Mobile)

**Total time:** ~22-29 days

### For Parallel Execution (Multiple developers):
1. Developer A: Database + Backend core (Plan 1 + Plan 2 Part 1)
2. Developer B: Web Frontend (Plan 3) - Uses mock API initially
3. Developer C: Mobile (Plan 4) - Uses mock API initially
4. Developer A completes Plan 2 remaining parts
5. Developers B & C integrate real API

**Total time:** ~10-12 days with coordination

### For AI Agents:
**Use superpowers:subagent-driven-development:**
- Dispatch 4 independent subagents (one per sub-plan)
- Each executes their plan to completion
- Coordinator ensures dependency ordering (Database → Backend → Web/Mobile)

---

## Definition of Done (For Each Plan)

- [ ] All code written per spec
- [ ] All tests passing (>80% coverage)
- [ ] Code reviewed (linting, security, style)
- [ ] Committed with clear messages
- [ ] Documentation updated
- [ ] Ready for next phase

---

## Key Decisions Made

1. **Monolithic Backend:** Easier to start, can split to microservices later
2. **Prisma ORM:** Type-safe, migration-friendly, great DX
3. **Zod validation:** Lightweight, no runtime dependencies
4. **Modular architecture:** Each NestJS module is self-contained
5. **TDD approach:** Write failing tests first in each plan
6. **Docker from day 1:** Consistency across environments
7. **Offline-first mobile:** SQLite sync with backend
8. **Git worktrees for isolation:** Each sub-plan in its own branch

---

## Reference Links

- Design Spec: `docs/superpowers/specs/2026-03-10-meow-metrics-app-design.md`
- Database Plan: `docs/superpowers/plans/2026-03-10-meow-metrics-database.md`
- Backend Plan: `docs/superpowers/plans/2026-03-10-meow-metrics-backend.md`
- Web Plan: `docs/superpowers/plans/2026-03-10-meow-metrics-web.md`
- Mobile Plan: `docs/superpowers/plans/2026-03-10-meow-metrics-mobile.md`

---

**Plan approved:** 2026-03-10
**Next step:** Execute sub-plans using superpowers:subagent-driven-development
