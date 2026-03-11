# Meow Metrics Backend API

Complete NestJS 11 API for managing urban cat colonies with full-featured database, authentication, and analytics.

## 🚀 Quick Start

### Prerequisites
- Node.js 20+
- PostgreSQL 15+
- Docker & Docker Compose (optional)

### Installation

```bash
# Install dependencies
npm install --legacy-peer-deps

# Copy environment file
cp .env.example .env.local

# Generate Prisma client
npm run prisma:generate
```

### Database Setup

```bash
# Start PostgreSQL with Docker (optional)
docker-compose up -d

# Run migrations
npm run prisma:migrate

# Seed test data
npm run prisma:seed

# View database in Prisma Studio
npm run prisma:studio
```

### Development

```bash
# Start development server (with hot reload)
npm run start:dev

# Run tests
npm run test

# Run tests with coverage
npm run test:cov
```

Server will be available at: `http://localhost:3001`
API Documentation: `http://localhost:3001/api-docs`

### Production

```bash
# Build
npm run build

# Start
npm run start:prod
```

---

## 📚 API Documentation

### Authentication

All protected endpoints require `Authorization: Bearer {token}` header.

**Login:**
```bash
POST /auth/login
{
  "email": "user@example.com",
  "password": "password"
}
```

**Register:**
```bash
POST /auth/register
{
  "email": "user@example.com",
  "password": "password",
  "role": "volunteer" | "coordinator" | "admin"
}
```

**Refresh Token:**
```bash
POST /auth/refresh
{
  "refreshToken": "token"
}
```

### Colonies

```bash
# Create colony
POST /colonies
{
  "name": "Colony Name",
  "latitude": 40.4168,
  "longitude": -3.7038,
  "address": "Address",
  "city": "City"
}

# List colonies (paginated)
GET /colonies?skip=0&take=20

# Get colony details
GET /colonies/:id

# Update colony
PATCH /colonies/:id
{
  "name": "New Name",
  "description": "New Description"
}

# Delete colony
DELETE /colonies/:id
```

### Cats

```bash
# Register cat
POST /cats
{
  "colonyId": "colony-id",
  "name": "Cat Name",
  "microchip": "12345",
  "color": "Orange",
  "gender": "MALE" | "FEMALE" | "UNKNOWN"
}

# List colony cats
GET /cats?colonyId=colony-id

# Get cat details
GET /cats/:id

# Update cat
PATCH /cats/:id
{
  "name": "New Name",
  "healthStatus": "HEALTHY" | "SICK" | "INJURED" | "DECEASED"
}

# Delete cat
DELETE /cats/:id
```

### Sterilization (CER)

```bash
# Create sterilization record
POST /sterilizations
{
  "catId": "cat-id",
  "colonyId": "colony-id",
  "status": "PENDING" | "SCHEDULED" | "COMPLETED"
}

# List colony sterilizations
GET /sterilizations/by-colony/:colonyId

# Get CER stats
GET /sterilizations/stats/:colonyId

# Update sterilization
PATCH /sterilizations/:id
{
  "status": "COMPLETED",
  "completionDate": "2026-03-11T00:00:00Z"
}
```

### Health Records

```bash
# Create health record
POST /health
{
  "catId": "cat-id",
  "colonyId": "colony-id",
  "recordType": "VACCINATION" | "TREATMENT" | "INJURY" | "CHECKUP",
  "description": "Description"
}

# Get cat health history
GET /health/by-cat/:catId

# Get colony health records
GET /health/by-colony/:colonyId

# Get health stats
GET /health/stats/:colonyId
```

### Collaboration

```bash
# Send collaboration invite
POST /collaborations/invite
{
  "colonyId": "colony-id",
  "userId": "user-id",
  "role": "OWNER" | "EDITOR" | "VIEWER"
}

# Accept invitation
PATCH /collaborations/accept/:id

# Reject invitation
PATCH /collaborations/reject/:id

# Get colony collaborators
GET /collaborations/colony/:colonyId

# Remove collaborator
DELETE /collaborations/:id
```

### Reports

```bash
# Get colony statistics
GET /reports/colony/:colonyId/stats

# Get user statistics
GET /reports/user/stats

# Generate report
POST /reports/colony/:colonyId/generate
{
  "startDate": "2026-01-01",
  "endDate": "2026-03-11"
}

# Get colony reports
GET /reports/colony/:colonyId
```

---

## 🏗️ Architecture

```
src/
├── auth/              # JWT authentication & login
├── users/             # User management
├── colonies/          # Colony CRUD
├── cats/              # Cat registration & tracking
├── sterilization/     # CER sterilization tracking
├── health/            # Health records
├── collaboration/     # Invitations & permissions
├── reports/           # Analytics & statistics
├── database/          # Prisma ORM service
├── common/            # Guards, pipes, decorators
├── config/            # Environment configuration
└── main.ts            # Application entry point
```

## 🔐 Security

- ✅ JWT authentication with refresh tokens
- ✅ Password hashing with bcrypt
- ✅ Role-based access control (RBAC)
- ✅ Ownership validation on protected resources
- ✅ Input validation with Zod schemas
- ✅ CORS protection
- ✅ Audit logging

## 📊 Database Schema

- **Users:** 3 roles (Volunteer, Coordinator, Admin)
- **Colonies:** With locations and ownership
- **Cats:** With microchip tracking and health status
- **Sterilization:** CER program tracking
- **Health Records:** Timeline of vaccinations, treatments, injuries
- **Collaborators:** Invitation-based access control
- **Reports:** Statistics and aggregations
- **Audit Logs:** Complete action tracking

## 🧪 Testing

```bash
# Run all tests
npm run test

# Run specific test file
npm run test -- auth.service.spec.ts

# Watch mode
npm run test:watch

# Coverage report
npm run test:cov
```

Target: **>80% code coverage**

## 📦 Dependencies

- **@nestjs/core** - Framework
- **@nestjs/jwt** - JWT authentication
- **@nestjs/passport** - Passport.js integration
- **@nestjs/swagger** - API documentation
- **@prisma/client** - ORM
- **bcryptjs** - Password hashing
- **zod** - Schema validation
- **passport-jwt** - JWT strategy

## 🚢 Deployment

### Docker

```bash
# Build image
docker build -t meow-metrics-api:latest .

# Run container
docker run -p 3001:3001 \
  -e DATABASE_URL="postgresql://..." \
  -e JWT_SECRET="your-secret" \
  meow-metrics-api:latest
```

### Environment Variables

```env
DATABASE_URL=postgresql://user:password@host:5432/meow_metrics
JWT_SECRET=your-super-secret-key
PORT=3001
NODE_ENV=production
CORS_ORIGIN=http://localhost:3000
```

### CI/CD (GitHub Actions)

Auto-deploy on push to main branch with:
- Dependency install
- Database migrations
- Test execution
- Docker build and push
- ECS/K8s deployment

## 📝 License

MIT

## 👥 Team

Meow Metrics Development Team
