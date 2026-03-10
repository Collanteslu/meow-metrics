# Meow Metrics: Database Implementation Plan

> **For agentic workers:** Execute this plan first. It's a blocker for backend and all clients. Use TDD approach: schema definition → migrations → seeds → tests.

**Goal:** Create PostgreSQL database with complete Prisma schema, migrations, and seed data for local development and testing.

**Architecture:** Single PostgreSQL database, Prisma as ORM, migrations-based schema evolution.

**Tech Stack:** PostgreSQL 15+, Prisma 5.x, Node.js

**Estimated time:** 2-3 days

---

## Chunk 1: Project Setup & Database Connection

### Task 1: Initialize NestJS backend project

**Files:**
- Create: `apps/backend/package.json`
- Create: `apps/backend/tsconfig.json`
- Create: `apps/backend/nest-cli.json`
- Create: `apps/backend/.env.example`
- Create: `apps/backend/Dockerfile`

- [ ] **Step 1: Create backend directory structure**

```bash
mkdir -p apps/backend/src/{modules,common,database}
cd apps/backend
npm init -y
```

- [ ] **Step 2: Install NestJS dependencies**

```bash
npm install @nestjs/common @nestjs/core @nestjs/config @nestjs/jwt @nestjs/passport passport passport-jwt bcrypt
npm install -D @types/node @types/express typescript ts-node tsconfig-paths jest @types/jest ts-jest
npm install prisma @prisma/client zod
```

Expected: All packages installed, node_modules created

- [ ] **Step 3: Create tsconfig.json**

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2021",
    "lib": ["ES2021"],
    "declaration": true,
    "outDir": "./dist",
    "baseUrl": "./src",
    "paths": {
      "@/*": ["*"]
    },
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "test", "**/*spec.ts"]
}
```

- [ ] **Step 4: Create .env.example**

```env
# Database
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/meow_metrics_dev"
DATABASE_URL_TEST="postgresql://postgres:postgres@localhost:5432/meow_metrics_test"

# JWT
JWT_SECRET="your-super-secret-key-change-in-production"
JWT_EXPIRATION="900" # 15 minutes
JWT_REFRESH_EXPIRATION="604800" # 7 days

# App
NODE_ENV="development"
APP_PORT=3000
```

- [ ] **Step 5: Create Dockerfile**

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start:prod"]
```

- [ ] **Step 6: Update package.json scripts**

```json
{
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "build": "nest build",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:migrate:deploy": "prisma migrate deploy",
    "prisma:seed": "ts-node prisma/seed.ts",
    "prisma:studio": "prisma studio"
  }
}
```

- [ ] **Step 7: Commit**

```bash
git add apps/backend/
git commit -m "chore: initialize NestJS backend project with dependencies"
```

---

### Task 2: Set up Prisma and PostgreSQL connection

**Files:**
- Create: `apps/backend/prisma/.env.local`
- Create: `apps/backend/prisma/schema.prisma` (basic)
- Create: `docker-compose.yml`

- [ ] **Step 1: Copy .env.example to .env.local**

```bash
cd apps/backend
cp .env.example .env.local
```

- [ ] **Step 2: Create docker-compose.yml in project root**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: meow_metrics_db
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: meow_metrics_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  postgres_test:
    image: postgres:15-alpine
    container_name: meow_metrics_db_test
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: meow_metrics_test
    ports:
      - "5433:5432"
    volumes:
      - postgres_test_data:/var/lib/postgresql/data

volumes:
  postgres_data:
  postgres_test_data:
```

- [ ] **Step 3: Start PostgreSQL with Docker Compose**

```bash
docker-compose up -d
```

Expected: Postgres containers running on ports 5432 and 5433

- [ ] **Step 4: Initialize Prisma**

```bash
cd apps/backend
npx prisma init --datasource-provider postgresql
```

Expected: `prisma/schema.prisma` created

- [ ] **Step 5: Verify database connection**

```bash
npx prisma db push --skip-generate
```

Expected: Connection successful, "Database reset" message

- [ ] **Step 6: Commit**

```bash
git add docker-compose.yml apps/backend/prisma/
git commit -m "feat: set up PostgreSQL and Prisma ORM"
```

---

## Chunk 2: Prisma Schema Definition

### Task 3: Define User and Authentication entities

**Files:**
- Modify: `apps/backend/prisma/schema.prisma`

- [ ] **Step 1: Create basic schema structure**

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ============ ENUMS ============

enum UserRole {
  GUARDIAN
  ORGANIZATION_MANAGER
  MUNICIPALITY_ADMIN
}

enum UserStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

// ============ USERS ============

model User {
  id                 String   @id @default(cuid())
  email              String   @unique
  password_hash      String
  name               String
  phone              String?
  role               UserRole @default(GUARDIAN)
  status             UserStatus @default(ACTIVE)
  organization_id    String?
  profile_photo_url  String?
  last_login         DateTime?
  created_at         DateTime @default(now())
  updated_at         DateTime @updatedAt

  // Relations
  organization       Organization? @relation("ManagerOf", fields: [organization_id], references: [id])
  colonies_owned     Colony[]       @relation("Owner")
  collaborated_colonies Collaborator[]
  health_records     HealthRecord[]
  sterilizations     Sterilization[]
  audit_logs         AuditLog[]
  invitations_sent   Collaboration?

  @@index([email])
  @@index([organization_id])
}

model Organization {
  id          String   @id @default(cuid())
  name        String
  description String?
  logo_url    String?
  website     String?
  managers    User[]   @relation("ManagerOf")
  members     Collaborator[]
  colonies    Colony[]
  created_at  DateTime @default(now())
  updated_at  DateTime @updatedAt
}
```

- [ ] **Step 2: Run migration to create User and Organization tables**

```bash
npx prisma migrate dev --name init_users_organizations
```

Expected: Migration created, tables created in database

- [ ] **Step 3: Verify schema**

```bash
npx prisma db push
```

Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add apps/backend/prisma/
git commit -m "feat: define User and Organization entities in Prisma schema"
```

---

### Task 4: Define Colony and Location entities

**Files:**
- Modify: `apps/backend/prisma/schema.prisma`

- [ ] **Step 1: Add Location and Colony models**

```prisma
// Add to schema.prisma

enum ColonyStatus {
  ACTIVE
  INACTIVE
  CLOSED
}

// ============ LOCATIONS ============

model Location {
  id          String   @id @default(cuid())
  latitude    Float
  longitude   Float
  address     String
  city        String
  postal_code String?
  country     String   @default("Spain")
  created_at  DateTime @default(now())
  updated_at  DateTime @updatedAt

  // Relations
  colonies    Colony[]

  @@index([city])
}

// ============ COLONIES ============

model Colony {
  id                     String   @id @default(cuid())
  name                   String
  location_id            String
  owner_id               String
  organization_id        String?
  description            String?
  established_date       DateTime?
  status                 ColonyStatus @default(ACTIVE)
  estimated_population   Int?
  notes                  String?
  created_at             DateTime @default(now())
  updated_at             DateTime @updatedAt

  // Relations
  location               Location       @relation(fields: [location_id], references: [id], onDelete: Cascade)
  owner                  User           @relation("Owner", fields: [owner_id], references: [id], onDelete: Cascade)
  organization           Organization?  @relation(fields: [organization_id], references: [id], onDelete: SetNull)
  cats                   Cat[]
  collaborators          Collaborator[]
  sterilizations         Sterilization[]
  health_records         HealthRecord[]
  reports                Report[]

  @@index([location_id])
  @@index([owner_id])
  @@index([organization_id])
  @@index([name])
}
```

- [ ] **Step 2: Run migration**

```bash
npx prisma migrate dev --name add_location_colony
```

Expected: Tables created

- [ ] **Step 3: Commit**

```bash
git add apps/backend/prisma/
git commit -m "feat: define Location and Colony entities"
```

---

### Task 5: Define Cat and Health-related entities

**Files:**
- Modify: `apps/backend/prisma/schema.prisma`

- [ ] **Step 1: Add Cat and HealthRecord models**

```prisma
// Add to schema.prisma

enum CatGender {
  MALE
  FEMALE
  UNKNOWN
}

enum CatHealthStatus {
  HEALTHY
  SICK
  INJURED
  DECEASED
}

enum SterilizationStatus {
  PENDING
  SCHEDULED
  COMPLETED
  FAILED
  CANCELLED
}

enum HealthRecordType {
  VACCINATION
  TREATMENT
  INJURY
  CHECKUP
  OTHER
}

// ============ CATS ============

model Cat {
  id                     String   @id @default(cuid())
  colony_id              String
  name                   String?
  microchip              String?  @unique
  color                  String?
  distinctive_marks      String?
  age                    Int?
  gender                 CatGender @default(UNKNOWN)
  health_status          CatHealthStatus @default(HEALTHY)
  sterilization_status   SterilizationStatus @default(PENDING)
  photo_url              String?
  date_registered        DateTime @default(now())
  notes                  String?
  created_at             DateTime @default(now())
  updated_at             DateTime @updatedAt

  // Relations
  colony                 Colony         @relation(fields: [colony_id], references: [id], onDelete: Cascade)
  sterilizations         Sterilization[]
  health_records         HealthRecord[]

  @@index([colony_id])
  @@index([microchip])
}

// ============ STERILIZATIONS (CER) ============

model Sterilization {
  id              String   @id @default(cuid())
  cat_id          String
  colony_id       String
  status          SterilizationStatus @default(PENDING)
  scheduled_date  DateTime?
  completion_date DateTime?
  veterinarian    String?
  clinic_name     String?
  cost            Float?
  notes           String?
  certificate_url String?
  recorded_by     String
  created_at      DateTime @default(now())
  updated_at      DateTime @updatedAt

  // Relations
  cat             Cat      @relation(fields: [cat_id], references: [id], onDelete: Cascade)
  colony          Colony   @relation(fields: [colony_id], references: [id], onDelete: Cascade)
  recorded_by_user User    @relation(fields: [recorded_by], references: [id], onDelete: SetNull)

  @@index([cat_id])
  @@index([colony_id])
  @@index([status])
}

// ============ HEALTH RECORDS ============

model HealthRecord {
  id              String   @id @default(cuid())
  cat_id          String
  colony_id       String
  record_type     HealthRecordType
  description     String
  date_recorded   DateTime @default(now())
  veterinarian    String?
  medications     String?
  next_followup   DateTime?
  recorded_by     String
  created_at      DateTime @default(now())
  updated_at      DateTime @updatedAt

  // Relations
  cat             Cat      @relation(fields: [cat_id], references: [id], onDelete: Cascade)
  colony          Colony   @relation(fields: [colony_id], references: [id], onDelete: Cascade)
  recorded_by_user User    @relation(fields: [recorded_by], references: [id], onDelete: SetNull)

  @@index([cat_id])
  @@index([colony_id])
  @@index([record_type])
}
```

- [ ] **Step 2: Run migration**

```bash
npx prisma migrate dev --name add_cats_health_records
```

Expected: Tables created

- [ ] **Step 3: Commit**

```bash
git add apps/backend/prisma/
git commit -m "feat: define Cat, Sterilization, and HealthRecord entities"
```

---

### Task 6: Define Collaboration and Audit entities

**Files:**
- Modify: `apps/backend/prisma/schema.prisma`

- [ ] **Step 1: Add Collaborator, Collaboration, and AuditLog models**

```prisma
// Add to schema.prisma

enum CollaboratorRole {
  OWNER
  EDITOR
  VIEWER
}

enum CollaborationStatus {
  PENDING
  ACCEPTED
  REJECTED
}

enum AuditAction {
  CREATE
  UPDATE
  DELETE
  VIEW
}

// ============ COLLABORATORS ============

model Collaborator {
  id          String   @id @default(cuid())
  colony_id   String
  user_id     String
  role        CollaboratorRole @default(VIEWER)
  invited_by  String
  invited_at  DateTime @default(now())
  accepted_at DateTime?
  status      CollaborationStatus @default(PENDING)
  created_at  DateTime @default(now())
  updated_at  DateTime @updatedAt

  // Relations
  colony      Colony   @relation(fields: [colony_id], references: [id], onDelete: Cascade)
  user        User     @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@unique([colony_id, user_id])
  @@index([colony_id])
  @@index([user_id])
  @@index([status])
}

// ============ COLLABORATION (Invitations) ============

model Collaboration {
  id          String   @id @default(cuid())
  user_id     String   @unique
  invited_to_organization String?
  invited_by  String
  status      CollaborationStatus @default(PENDING)
  created_at  DateTime @default(now())
  updated_at  DateTime @updatedAt

  // Relations
  user        User     @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@index([status])
}

// ============ AUDIT LOG ============

model AuditLog {
  id          String   @id @default(cuid())
  entity_type String
  entity_id   String
  action      AuditAction
  user_id     String
  old_values  Json?
  new_values  Json?
  ip_address  String?
  timestamp   DateTime @default(now())

  // Relations
  user        User     @relation(fields: [user_id], references: [id], onDelete: SetNull)

  @@index([entity_type, entity_id])
  @@index([user_id])
  @@index([timestamp])
}

// ============ REPORTS ============

model Report {
  id              String   @id @default(cuid())
  colony_id       String
  report_type     String  // "Monthly", "Quarterly", "Annual", "CER", "Custom"
  period_start    DateTime
  period_end      DateTime
  generated_by    String
  data            Json
  file_url        String?
  created_at      DateTime @default(now())

  // Relations
  colony          Colony   @relation(fields: [colony_id], references: [id], onDelete: Cascade)

  @@index([colony_id])
  @@index([report_type])
}
```

- [ ] **Step 2: Fix User model foreign key reference**

```prisma
// Update in User model:
model User {
  // ... existing fields ...

  sterilizations     Sterilization[]     @relation("RecordedBy")
  health_records     HealthRecord[]      @relation("RecordedBy")
  // ... rest of fields
}

// Update in Sterilization model:
model Sterilization {
  // ... existing fields ...
  recorded_by_user User    @relation("RecordedBy", fields: [recorded_by], references: [id], onDelete: SetNull)
  // ... rest
}

// Update in HealthRecord model:
model HealthRecord {
  // ... existing fields ...
  recorded_by_user User    @relation("RecordedBy", fields: [recorded_by], references: [id], onDelete: SetNull)
  // ... rest
}
```

- [ ] **Step 3: Run migration**

```bash
npx prisma migrate dev --name add_collaboration_audit
```

Expected: Tables created, no constraint errors

- [ ] **Step 4: Verify complete schema**

```bash
npx prisma studio
```

Expected: Prisma Studio opens, shows all tables

- [ ] **Step 5: Commit**

```bash
git add apps/backend/prisma/
git commit -m "feat: define Collaborator, Collaboration, AuditLog, and Report entities"
```

---

## Chunk 3: Database Seeding & Testing

### Task 7: Create database seed file

**Files:**
- Create: `apps/backend/prisma/seed.ts`

- [ ] **Step 1: Create seed.ts file**

```typescript
// prisma/seed.ts

import { PrismaClient, UserRole, ColonyStatus, CatHealthStatus, SterilizationStatus } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Clear existing data
  console.log('🗑️  Clearing existing data...');
  await prisma.auditLog.deleteMany();
  await prisma.collaboration.deleteMany();
  await prisma.collaborator.deleteMany();
  await prisma.report.deleteMany();
  await prisma.healthRecord.deleteMany();
  await prisma.sterilization.deleteMany();
  await prisma.cat.deleteMany();
  await prisma.colony.deleteMany();
  await prisma.location.deleteMany();
  await prisma.organization.deleteMany();
  await prisma.user.deleteMany();

  console.log('✅ Data cleared');

  // Hash password
  const passwordHash = await bcrypt.hash('password123', 10);

  // Create organizations
  console.log('📦 Creating organizations...');
  const org = await prisma.organization.create({
    data: {
      name: 'Gatitos Felices',
      description: 'Organization for cat welfare',
      website: 'https://gatitos.es',
    },
  });

  // Create users
  console.log('👥 Creating users...');
  const guardian = await prisma.user.create({
    data: {
      email: 'guardian@example.com',
      password_hash: passwordHash,
      name: 'Juan García',
      phone: '+34666666666',
      role: UserRole.GUARDIAN,
    },
  });

  const orgManager = await prisma.user.create({
    data: {
      email: 'manager@example.com',
      password_hash: passwordHash,
      name: 'María López',
      phone: '+34677777777',
      role: UserRole.ORGANIZATION_MANAGER,
      organization_id: org.id,
    },
  });

  const admin = await prisma.user.create({
    data: {
      email: 'admin@example.com',
      password_hash: passwordHash,
      name: 'Admin Madrid',
      role: UserRole.MUNICIPALITY_ADMIN,
    },
  });

  // Create locations
  console.log('📍 Creating locations...');
  const loc1 = await prisma.location.create({
    data: {
      latitude: 40.4168,
      longitude: -3.7038,
      address: 'Parque Retiro, Madrid',
      city: 'Madrid',
      postal_code: '28001',
    },
  });

  const loc2 = await prisma.location.create({
    data: {
      latitude: 40.4189,
      longitude: -3.6939,
      address: 'Plaza Mayor, Madrid',
      city: 'Madrid',
      postal_code: '28012',
    },
  });

  // Create colonies
  console.log('🏘️  Creating colonies...');
  const colony1 = await prisma.colony.create({
    data: {
      name: 'Colonia Retiro',
      location_id: loc1.id,
      owner_id: guardian.id,
      organization_id: org.id,
      description: 'Comunidad de gatos en el Parque Retiro',
      estimated_population: 15,
      status: ColonyStatus.ACTIVE,
    },
  });

  const colony2 = await prisma.colony.create({
    data: {
      name: 'Colonia Plaza Mayor',
      location_id: loc2.id,
      owner_id: orgManager.id,
      organization_id: org.id,
      description: 'Gatos en la zona histórica',
      estimated_population: 8,
      status: ColonyStatus.ACTIVE,
    },
  });

  // Create cats
  console.log('🐱 Creating cats...');
  const cat1 = await prisma.cat.create({
    data: {
      colony_id: colony1.id,
      name: 'Misu',
      color: 'Naranja',
      gender: 'MALE',
      health_status: CatHealthStatus.HEALTHY,
      sterilization_status: SterilizationStatus.COMPLETED,
      date_registered: new Date('2025-01-01'),
    },
  });

  const cat2 = await prisma.cat.create({
    data: {
      colony_id: colony1.id,
      name: 'Luna',
      color: 'Negra',
      gender: 'FEMALE',
      health_status: CatHealthStatus.HEALTHY,
      sterilization_status: SterilizationStatus.PENDING,
      date_registered: new Date('2025-02-01'),
    },
  });

  // Create sterilization records
  console.log('✂️  Creating sterilization records...');
  await prisma.sterilization.create({
    data: {
      cat_id: cat1.id,
      colony_id: colony1.id,
      status: SterilizationStatus.COMPLETED,
      completion_date: new Date('2025-01-15'),
      veterinarian: 'Dr. López',
      clinic_name: 'Clínica Veterinaria Central',
      cost: 50.0,
      recorded_by: guardian.id,
    },
  });

  // Create health records
  console.log('🏥 Creating health records...');
  await prisma.healthRecord.create({
    data: {
      cat_id: cat2.id,
      colony_id: colony1.id,
      record_type: 'VACCINATION',
      description: 'Vacunación de rabia',
      date_recorded: new Date('2025-02-10'),
      veterinarian: 'Dra. García',
      next_followup: new Date('2026-02-10'),
      recorded_by: guardian.id,
    },
  });

  // Create collaborator
  console.log('🤝 Creating collaborators...');
  await prisma.collaborator.create({
    data: {
      colony_id: colony1.id,
      user_id: orgManager.id,
      role: 'EDITOR',
      invited_by: guardian.id,
      status: 'ACCEPTED',
      accepted_at: new Date(),
    },
  });

  console.log('✨ Seed completed successfully!');
  console.log('\n📋 Test Users:');
  console.log(`Guardian: guardian@example.com / password123`);
  console.log(`Manager: manager@example.com / password123`);
  console.log(`Admin: admin@example.com / password123`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

- [ ] **Step 2: Add seed script to package.json (already done in Task 1)**

Verify in `apps/backend/package.json`:
```json
"prisma:seed": "ts-node prisma/seed.ts"
```

- [ ] **Step 3: Run seed**

```bash
cd apps/backend
npm run prisma:seed
```

Expected: "Seed completed successfully!" message

- [ ] **Step 4: Verify data in Prisma Studio**

```bash
npm run prisma:studio
```

Expected: 3 users visible, 2 colonies, 2 cats, etc.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/prisma/
git commit -m "feat: create database seed with test data"
```

---

### Task 8: Create database tests

**Files:**
- Create: `apps/backend/test/database.spec.ts`

- [ ] **Step 1: Create test file**

```typescript
// test/database.spec.ts

import { PrismaClient } from '@prisma/client';

describe('Database Schema', () => {
  let prisma: PrismaClient;

  beforeAll(() => {
    prisma = new PrismaClient({
      datasources: {
        db: {
          url: process.env.DATABASE_URL_TEST,
        },
      },
    });
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  describe('User model', () => {
    it('should create a user with required fields', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'test@example.com',
          password_hash: 'hashed_password',
          name: 'Test User',
          role: 'GUARDIAN',
        },
      });

      expect(user).toBeDefined();
      expect(user.email).toBe('test@example.com');
      expect(user.role).toBe('GUARDIAN');
    });

    it('should not allow duplicate emails', async () => {
      await prisma.user.create({
        data: {
          email: 'unique@example.com',
          password_hash: 'hash1',
          name: 'User 1',
        },
      });

      expect(
        prisma.user.create({
          data: {
            email: 'unique@example.com',
            password_hash: 'hash2',
            name: 'User 2',
          },
        }),
      ).rejects.toThrow();
    });
  });

  describe('Colony and Location models', () => {
    it('should create colony with location', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'owner@example.com',
          password_hash: 'hash',
          name: 'Owner',
        },
      });

      const location = await prisma.location.create({
        data: {
          latitude: 40.4168,
          longitude: -3.7038,
          address: 'Test Address',
          city: 'Madrid',
        },
      });

      const colony = await prisma.colony.create({
        data: {
          name: 'Test Colony',
          location_id: location.id,
          owner_id: user.id,
        },
      });

      expect(colony.name).toBe('Test Colony');
      expect(colony.location_id).toBe(location.id);
    });
  });

  describe('Cat model', () => {
    it('should create cat with colony', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'cat@example.com',
          password_hash: 'hash',
          name: 'Cat Owner',
        },
      });

      const location = await prisma.location.create({
        data: {
          latitude: 40.0,
          longitude: -3.0,
          address: 'Test',
          city: 'Madrid',
        },
      });

      const colony = await prisma.colony.create({
        data: {
          name: 'Cat Colony',
          location_id: location.id,
          owner_id: user.id,
        },
      });

      const cat = await prisma.cat.create({
        data: {
          colony_id: colony.id,
          name: 'Whiskers',
          color: 'Orange',
          gender: 'MALE',
        },
      });

      expect(cat.name).toBe('Whiskers');
      expect(cat.colony_id).toBe(colony.id);
    });
  });

  describe('Audit logging', () => {
    it('should create audit log entry', async () => {
      const user = await prisma.user.create({
        data: {
          email: 'audit@example.com',
          password_hash: 'hash',
          name: 'Audit User',
        },
      });

      const log = await prisma.auditLog.create({
        data: {
          entity_type: 'COLONY',
          entity_id: 'col_123',
          action: 'CREATE',
          user_id: user.id,
          new_values: { name: 'New Colony' },
        },
      });

      expect(log.action).toBe('CREATE');
      expect(log.entity_type).toBe('COLONY');
    });
  });
});
```

- [ ] **Step 2: Update Jest config in package.json**

```json
{
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": ".",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "collectCoverageFrom": [
      "src/**/*.(t|j)s"
    ],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
```

- [ ] **Step 3: Run tests**

```bash
npm test -- test/database.spec.ts
```

Expected: All tests pass

- [ ] **Step 4: Commit**

```bash
git add apps/backend/test/
git commit -m "test: add database schema validation tests"
```

---

## Chunk 4: Finalization

### Task 9: Document database setup and cleanup

**Files:**
- Create: `apps/backend/DATABASE.md`

- [ ] **Step 1: Create DATABASE.md**

```markdown
# Database Setup Guide

## Overview
Meow Metrics uses PostgreSQL with Prisma ORM for type-safe database access.

## Quick Start

### 1. Start PostgreSQL with Docker Compose
From project root:
```bash
docker-compose up -d
```

This starts:
- Development database: `meow_metrics_dev` on port 5432
- Test database: `meow_metrics_test` on port 5433

### 2. Run Migrations
```bash
cd apps/backend
npm run prisma:migrate
```

This applies all pending migrations to the development database.

### 3. Seed Development Data
```bash
npm run prisma:seed
```

Populates database with test users, colonies, and cats.

### 4. Access Prisma Studio
```bash
npm run prisma:studio
```

Opens browser UI to view/edit database records.

## Development Commands

```bash
# Apply new migrations
npm run prisma:migrate

# Generate Prisma client after schema changes
npm run prisma:generate

# Reset database and reapply all migrations
npm run prisma:migrate reset

# View database in Studio
npm run prisma:studio

# Run database tests
npm test -- test/database.spec.ts
```

## Creating New Migrations

When you update `prisma/schema.prisma`:

```bash
npm run prisma:migrate -- --name <name>
```

Example:
```bash
npm run prisma:migrate -- --name add_user_bio
```

This creates a new migration file in `prisma/migrations/`.

## Test Database

For running tests, use `DATABASE_URL_TEST`:

```bash
DATABASE_URL="postgresql://postgres:postgres@localhost:5433/meow_metrics_test" npm test
```

The test database automatically resets for each test suite.

## Production Deployment

On production server:

```bash
DATABASE_URL="<prod-database-url>" npm run prisma:migrate:deploy
```

Use `migrate:deploy` (not `migrate dev`) in production - it doesn't create new migration files, only applies existing ones.

## Troubleshooting

**Connection refused error:**
- Ensure Docker containers are running: `docker-compose ps`
- Check DATABASE_URL in `.env.local`

**Migration conflicts:**
- Each migration must have a unique name
- If you have conflicting migrations, resolve manually or reset with `npm run prisma:migrate reset`

**Schema out of sync:**
- Run `npm run prisma:generate` to regenerate Prisma client
- Run `npm run prisma:migrate` to update schema

## Data Model

See `docs/superpowers/specs/2026-03-10-meow-metrics-app-design.md` section 4 for complete data model documentation.
```

- [ ] **Step 2: Create cleanup script (optional but helpful)**

```bash
# apps/backend/scripts/reset-db.sh
#!/bin/bash
set -e

echo "🗑️  Resetting database..."
npm run prisma:migrate reset -- --force

echo "🌱 Seeding database..."
npm run prisma:seed

echo "✅ Database reset complete!"
```

- [ ] **Step 3: Make script executable and add to package.json**

```bash
chmod +x apps/backend/scripts/reset-db.sh
```

Update package.json:
```json
{
  "scripts": {
    "db:reset": "node scripts/reset-db.sh"
  }
}
```

- [ ] **Step 4: Commit documentation**

```bash
git add apps/backend/DATABASE.md apps/backend/scripts/
git commit -m "docs: add database setup and maintenance guide"
```

---

### Task 10: Final verification and summary

- [ ] **Step 1: Verify all migrations applied**

```bash
cd apps/backend
npx prisma migrate status
```

Expected: "Database is up to date"

- [ ] **Step 2: Verify seed data**

```bash
npx prisma studio
```

Expected: Can browse all tables with test data

- [ ] **Step 3: Run all database tests**

```bash
npm test -- test/database.spec.ts
```

Expected: All tests pass, >80% coverage

- [ ] **Step 4: Create final summary commit**

```bash
git add -A
git commit -m "chore: finalize database schema and seeding"
```

- [ ] **Step 5: Verify git log**

```bash
git log --oneline | head -10
```

Expected: All 10+ database-related commits visible

---

## Checklist for Completion

- ✅ PostgreSQL running in Docker
- ✅ Prisma initialized and configured
- ✅ All 8 models defined (User, Organization, Location, Colony, Cat, Sterilization, HealthRecord, Collaborator, Collaboration, AuditLog, Report)
- ✅ All migrations created and applied
- ✅ Seed data loaded
- ✅ Database tests passing
- ✅ Documentation complete
- ✅ All changes committed to git

---

**Database plan ready for backend team to begin.**

Next step: Execute `2026-03-10-meow-metrics-backend.md` to build the API layer.
