# Meow Metrics: Backend API Implementation Plan

> **Execution:** Use subagent-driven-development. Database plan must complete first.

**Goal:** Build complete NestJS API with all modules, authentication, authorization, and business logic.

**Architecture:** Modular NestJS backend with controllers → services → repositories pattern. Zod for validation, Prisma for data access.

**Tech Stack:** NestJS 11, Prisma, PostgreSQL, JWT, Zod, Jest

**Estimated time:** 10-12 days (can be split into 5 parts for parallel work)

---

## Part 1: Core Infrastructure & Authentication (2-3 days)

### Module Structure
```
src/
├── auth/                    # JWT, login/register, refresh tokens
├── users/                   # User management, profiles
├── common/                  # Guards, pipes, interceptors, decorators
├── config/                  # Environment, database config
├── database/                # Prisma service
└── main.ts
```

### Key Tasks
1. **NestJS app scaffolding** - Create main.ts, app.module.ts, configuration
2. **Database service** - Wrap Prisma, add global error handling
3. **Auth module** - JWT strategy, guards, login/register endpoints
4. **User module** - CRUD, profile management, role validation
5. **Testing setup** - Jest configuration, first unit tests
6. **API documentation** - Swagger/OpenAPI setup

### Endpoints to Implement
- `POST /auth/register` - Create new user
- `POST /auth/login` - Get JWT and refresh token
- `POST /auth/refresh` - Refresh access token
- `GET /users/me` - Get current user profile
- `PATCH /users/:id` - Update user profile
- `GET /users/:id` - Get user details (admin only)

---

## Part 2: Colonies Management (2-3 days)

### Module Structure
```
src/colonies/
├── colonies.controller.ts
├── colonies.service.ts
├── colonies.repository.ts
├── dto/                     # CreateColonyDto, UpdateColonyDto with Zod
├── entities/                # ColonyEntity
└── guards/                  # OwnerGuard, IsColaboratorGuard
```

### Key Tasks
1. **Colony CRUD** - Create, read, update, delete colonies
2. **Location management** - Handle lat/long, address validation
3. **Ownership validation** - Ensure users can only manage their colonies
4. **Query filters** - Search by city, name, status
5. **Pagination** - Large list handling

### Endpoints
- `POST /colonies` - Create colony (authenticated)
- `GET /colonies` - List colonies (filtered by city/user)
- `GET /colonies/:id` - Get colony details
- `PATCH /colonies/:id` - Update colony (owner only)
- `DELETE /colonies/:id` - Delete colony (owner only)

---

## Part 3: Cats & Health Records (2-3 days)

### Modules
```
src/cats/
src/sterilization/
src/health/
```

### Key Tasks
1. **Cat registration** - Create, update, delete cat records
2. **Microchip tracking** - Unique validation, QR code support
3. **Sterilization CER** - Track CER program progress, schedule/complete
4. **Health records** - Vaccinations, treatments, injury reports
5. **Status tracking** - Health and sterilization status enums
6. **Photo management** - URL storage (actual upload to S3 by clients)

### Endpoints
```
POST /cats - Register new cat
GET /cats?colony_id=... - List colony cats
PATCH /cats/:id - Update cat info
DELETE /cats/:id - Delete cat

POST /sterilizations - Create CER record
PATCH /sterilizations/:id - Update status
GET /sterilizations?colony_id=... - List

POST /health - Create health record
GET /health/:cat_id - Cat health history
```

---

## Part 4: Collaboration & Permissions (2 days)

### Module
```
src/collaboration/
├── collaborators.service.ts
├── invitations.service.ts
├── role.guard.ts
```

### Key Tasks
1. **Invitations** - Send, accept, reject collaboration invites
2. **Collaborator roles** - Owner, Editor, Viewer permissions
3. **Access control** - Middleware to check permissions before operations
4. **Audit log** - Record all invitation changes
5. **Email notifications** - Invitation emails (can use mail service stub)

### Endpoints
```
POST /invitations - Send collaboration invite
PATCH /invitations/:id - Accept/reject
GET /collaborators/:colony_id - List colony collaborators
DELETE /collaborators/:id - Remove collaborator
```

---

## Part 5: Reports & Analytics (1-2 days)

### Module
```
src/reports/
├── reports.service.ts
├── analytics.service.ts
├── dto/ReportQuery.dto.ts
```

### Key Tasks
1. **Automatic calculations** - Population stats, CER progress, health summaries
2. **Date range filtering** - Monthly, quarterly, annual reports
3. **Data aggregation** - Group by colony, user, status
4. **Export support** - JSON structure ready for PDF/Excel conversion
5. **Caching** - Redis caching for expensive queries

### Endpoints
```
GET /reports - List reports for user
POST /reports - Generate custom report
GET /reports/:id - Get report data
GET /analytics/city/:city - City-wide stats (admin)
GET /analytics/colony/:colony_id - Colony stats
```

---

## Critical Implementation Details

### Validation
Every endpoint uses Zod schemas:
```typescript
// Example
const CreateColonySchema = z.object({
  name: z.string().min(3).max(255),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
});
```

### Authorization
Use custom guards:
```typescript
@UseGuards(AuthGuard)
@UseGuards(new OwnershipGuard('colony'))
```

### Testing
TDD approach - write tests first:
- Unit tests for services
- Integration tests for controllers
- E2E tests for critical flows

### Error Handling
Consistent error responses:
```typescript
{
  statusCode: 400,
  message: "Validation failed",
  errors: [...]
}
```

---

## Deliverables

- ✅ NestJS app running with all modules
- ✅ API documentation (Swagger)
- ✅ All endpoints tested and working
- ✅ Authentication/authorization working
- ✅ Database operations tested
- ✅ >80% test coverage
- ✅ All changes committed to git

---

**Backend plan complete. Ready for web/mobile clients to integrate.**
