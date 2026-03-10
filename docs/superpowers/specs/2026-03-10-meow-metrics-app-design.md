# Meow Metrics: Aplicación Completa de Gestión de Colonias Felinas

**Fecha:** 2026-03-10
**Status:** Aprobado
**Autor:** Brainstorming Session

---

## Resumen Ejecutivo

Meow Metrics es una aplicación colaborativa completa para la gestión de colonias felinas urbanas. Está diseñada para acompañar guardianes, organizaciones y municipios en el cuidado responsable de gatos comunitarios, con énfasis en programas CER (Captura, Esterilización y Retorno) y trazabilidad de acciones.

**Plataformas:** Web (Next.js 16) + Mobile (Flutter)
**Backend:** NestJS 11 + PostgreSQL
**Validación:** Zod
**Escalabilidad:** Robusta para cualquier escala

---

## 1. Visión y Objetivos

### Visión
Ser la plataforma central que transforma el trabajo voluntario de gestión de colonias felinas en información medible, trazable y colaborativa, fortaleciendo modelos de gestión responsables a nivel ciudad.

### Objetivos
- Centralizar registro de colonias, gatos y acciones sanitarias
- Facilitar colaboración entre guardianes, organizaciones y municipios
- Generar datos y reportes para decisiones basadas en evidencia
- Rastrear impacto de programas CER
- Cumplir con marcos legales (Ley 7/2023 en España)

---

## 2. Arquitectura General

### Componentes Principales

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   NEXT.JS 16    │     │  FLUTTER APP    │     │   ADMIN WEB     │
│   (Web Client)  │     │   (Mobile)      │     │   (Next.js)     │
└────────┬────────┘     └────────┬────────┘     └────────┬────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   NestJS 11 Backend     │
                    │   (API REST + GraphQL)  │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   PostgreSQL Database   │
                    │   (Normalized Schema)   │
                    └─────────────────────────┘
```

### Patrones Arquitectónicos
- **Monolítico modular:** Un único backend con módulos bien separados por dominio
- **API-first:** Todas las entidades accesibles vía API REST
- **Domain-Driven Design:** Módulos NestJS representan dominios de negocio
- **Layered Architecture:** Controllers → Services → Repositories → Database

---

## 3. Módulos Backend (NestJS)

Estructura de módulos:

```
src/
├── auth/                 # Autenticación, JWT, refresh tokens
├── users/                # Gestión de usuarios, perfil, preferences
├── colonies/             # CRUD colonias, ubicaciones
├── cats/                 # Registro individual de gatos
├── sterilization/        # Programa CER, seguimiento
├── health/               # Historial sanitario, tratamientos
├── actions/              # Historial de acciones (auditoría)
├── collaboration/        # Invitaciones, permisos compartidos
├── reports/              # Generación de reportes y estadísticas
├── common/               # Guards, pipes, interceptors, decoradores
├── config/               # Variables de entorno, configuración
└── database/             # Migrations, seeds, prisma schema
```

**Cada módulo incluye:**
- `dto/` - Data Transfer Objects con validación Zod
- `services/` - Lógica de negocio
- `controllers/` - Endpoints REST
- `entities/` - Modelos Prisma/TypeORM
- `guards/` - Autorización (ej: IsColonyOwner)
- `pipes/` - Transformación y validación de datos

---

## 4. Modelo de Datos (PostgreSQL)

### Entidades Principales

#### Users
```sql
Users (
  id UUID PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  phone VARCHAR,
  role ENUM (Guardian, OrganizationManager, MunicipalityAdmin),
  organization_id UUID FOREIGN KEY,
  profile_photo_url VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

#### Locations
```sql
Locations (
  id UUID PRIMARY KEY,
  latitude DECIMAL,
  longitude DECIMAL,
  address VARCHAR,
  city VARCHAR NOT NULL,
  postal_code VARCHAR
)
```

#### Colonies
```sql
Colonies (
  id UUID PRIMARY KEY,
  name VARCHAR NOT NULL,
  location_id UUID FOREIGN KEY,
  owner_id UUID FOREIGN KEY (users),
  description TEXT,
  established_date DATE,
  status ENUM (Active, Inactive, Closed),
  estimated_population INT,
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

#### Cats
```sql
Cats (
  id UUID PRIMARY KEY,
  colony_id UUID FOREIGN KEY,
  name VARCHAR,
  microchip VARCHAR UNIQUE,
  color VARCHAR,
  distinctive_marks TEXT,
  age INT,
  gender ENUM (Male, Female, Unknown),
  health_status ENUM (Healthy, Sick, Injured, Deceased),
  sterilization_status ENUM (Pending, Sterilized, Cannot),
  photo_url VARCHAR,
  date_registered TIMESTAMP,
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

#### Sterilizations (CER)
```sql
Sterilizations (
  id UUID PRIMARY KEY,
  cat_id UUID FOREIGN KEY,
  colony_id UUID FOREIGN KEY,
  status ENUM (Pending, Scheduled, Completed, Failed, Cancelled),
  scheduled_date DATE,
  completion_date DATE,
  veterinarian VARCHAR,
  clinic_name VARCHAR,
  cost DECIMAL,
  notes TEXT,
  certificate_url VARCHAR,
  recorded_by UUID FOREIGN KEY (users),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

#### HealthRecords
```sql
HealthRecords (
  id UUID PRIMARY KEY,
  cat_id UUID FOREIGN KEY,
  colony_id UUID FOREIGN KEY,
  record_type ENUM (Vaccination, Treatment, Injury, Checkup, Other),
  description TEXT,
  date_recorded DATE,
  veterinarian VARCHAR,
  medications TEXT,
  next_followup DATE,
  recorded_by UUID FOREIGN KEY (users),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

#### Collaborators
```sql
Collaborators (
  id UUID PRIMARY KEY,
  colony_id UUID FOREIGN KEY,
  user_id UUID FOREIGN KEY,
  role ENUM (Owner, Editor, Viewer),
  invited_by UUID FOREIGN KEY (users),
  invited_at TIMESTAMP,
  accepted_at TIMESTAMP,
  status ENUM (Pending, Accepted, Rejected)
)
```

#### AuditLog
```sql
AuditLog (
  id UUID PRIMARY KEY,
  entity_type VARCHAR,
  entity_id UUID,
  action ENUM (Create, Update, Delete, View),
  user_id UUID FOREIGN KEY,
  old_values JSONB,
  new_values JSONB,
  ip_address VARCHAR,
  timestamp TIMESTAMP
)
```

#### Reports
```sql
Reports (
  id UUID PRIMARY KEY,
  colony_id UUID FOREIGN KEY,
  report_type ENUM (Monthly, Quarterly, Annual, CER, Custom),
  period_start DATE,
  period_end DATE,
  generated_by UUID FOREIGN KEY (users),
  data_json JSONB,
  file_url VARCHAR,
  created_at TIMESTAMP
)
```

---

## 5. Sistema de Usuarios y Permisos

### Tipos de Usuarios

#### 1. Guardian
- Persona individual que cuida una o más colonias
- **Permisos:**
  - Crear colonias propias
  - Editar colonias que posee
  - Ver todas las colonias de su ciudad (lectura)
  - Ser invitado a colonias de otros
  - Registrar gatos en colonias asignadas
  - Registrar acciones sanitarias

#### 2. Organization Manager
- Representa una ONG, grupo voluntario u organización
- **Permisos:**
  - Crear colonias bajo su organización
  - Invitar guardianes a su organización
  - Gestionar permisos de miembros
  - Ver datos de todas sus colonias y guardianes
  - Acceso a reportes agregados del grupo

#### 3. Municipality Admin
- Administrador municipal o técnico de gestión urbana
- **Permisos:**
  - Acceso lectura a todas las colonias de su ciudad
  - Dashboard ciudad-wide con estadísticas
  - Gestión de programas CER a nivel municipal
  - Generación de reportes para fondos públicos
  - Auditoría completa de acciones

### Sistema de Control de Acceso (RBAC)

```typescript
// Guards en NestJS
- AuthGuard: Verificar JWT válido
- RoleGuard: Verificar rol del usuario
- OwnershipGuard: Verificar que es dueño del recurso
- CollaboratorGuard: Verificar que es colaborador invitado
- MunicipalityGuard: Verificar ciudad
```

### Invitaciones y Colaboración

```
1. Guardian A invita Guardian B a colonia X
2. Sistema envía email con link único
3. Guardian B acepta/rechaza
4. Si acepta, se registra acceso en Collaborators
5. Ahora ambos pueden editar colonia X
6. Cada acción queda auditada con quién la hizo
```

---

## 6. Flujos Principales de Negocio

### Flujo 1: Registrar Nueva Colonia

```
Usuario inicia sesión →
Navega a "Nueva Colonia" →
Completa formulario (nombre, ubicación, descripción) →
Backend valida con Zod →
Se crea en BD con owner = usuario actual →
Sistema genera ID único →
Redirección a vista de colonia →
Usuario puede invitar colaboradores
```

**Validaciones:**
- Nombre requerido, máx 255 caracteres
- Ubicación válida (lat/lng en rango)
- Descripción opcional, máx 2000 caracteres

### Flujo 2: Registrar Gato Individual

```
Usuario abre colonia →
Click "Agregar Gato" →
Formulario: nombre, foto, género, color, distintivos →
Opcional: escanear microchip (QR) →
Backend valida datos →
Foto se sube a S3/Cloud Storage →
Se registra en BD con audit log →
Gato aparece en tabla de la colonia
```

**Características:**
- Foto obligatoria (validar tamaño, formato)
- Microchip único por gato (opcional)
- Historial automático de quién lo registró
- Posibilidad de editar datos más tarde

### Flujo 3: Programa CER (Esterilización)

```
Guardián marca gato para esterilizar →
Sistema crea registro CER en estado "Pending" →
Puede asignar veterinario y fecha aproximada →
Cuando se realiza: actualiza estado a "Completed" →
Registra fecha real, veterinario, costo →
Sistema calcula impacto poblacional →
Reportes muestran progreso CER
```

**Datos generados para reportes:**
- % gatos esterilizados por colonia
- Velocidad de esterilización
- Proyección de estabilización poblacional
- Costo total vs presupuesto

### Flujo 4: Colaboración y Permisos

```
Guardián A abre colonia →
Click "Invitar Colaborador" →
Ingresa email de Guardián B →
Selecciona rol (Editor/Viewer) →
Sistema envía email con invitación →
Guardián B recibe notificación →
Si acepta, aparece en lista de colaboradores →
Ambos pueden editar/ver según rol →
Auditoría registra todas las acciones
```

**Roles en Colaboración:**
- **Owner:** Control total (puede invitar, eliminar colaboradores)
- **Editor:** Puede editar datos, agregar gatos
- **Viewer:** Solo lectura

### Flujo 5: Generación de Reportes

```
Usuario accede a "Reportes" →
Selecciona período (mensual/trimestral/anual) →
Elige tipo (CER, Sanitario, Estadístico) →
Sistema consulta base de datos →
Calcula métricas y genera visualizaciones →
Opción exportar a PDF/Excel →
Para Municipios: incluye datos de toda la ciudad
```

**Reportes automáticos:**
- Población actual por colonia
- Progreso esterilización (CER)
- Historial sanitario
- Acciones por usuario
- Tendencias temporales

---

## 7. Frontend Web (Next.js 16)

### Estructura de Carpetas

```
app/
├── (auth)/
│   ├── login/
│   │   └── page.tsx
│   ├── register/
│   │   └── page.tsx
│   └── forgot-password/
│       └── page.tsx
├── (dashboard)/
│   ├── layout.tsx
│   ├── page.tsx (Dashboard principal)
│   ├── colonies/
│   │   ├── page.tsx (Lista)
│   │   ├── [id]/
│   │   │   ├── page.tsx (Detalle)
│   │   │   ├── cats/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [catId]/page.tsx
│   │   │   ├── sterilizations/
│   │   │   │   └── page.tsx
│   │   │   ├── health/
│   │   │   │   └── page.tsx
│   │   │   └── collaborators/
│   │   │       └── page.tsx
│   │   └── new/
│   │       └── page.tsx
│   ├── reports/
│   │   ├── page.tsx
│   │   └── [id]/page.tsx
│   ├── settings/
│   │   └── page.tsx
│   └── admin/ (Solo para Municipality Admins)
│       ├── page.tsx
│       └── users/page.tsx
├── layout.tsx
├── page.tsx
└── globals.css

lib/
├── api/
│   ├── client.ts (Axios/Fetch wrapper)
│   ├── colonies.ts
│   ├── cats.ts
│   ├── sterilizations.ts
│   ├── auth.ts
│   └── reports.ts
├── hooks/
│   ├── useColonies.ts
│   ├── useCats.ts
│   ├── useAuth.ts
│   └── useReports.ts
├── schemas/
│   ├── colony.ts (Zod)
│   ├── cat.ts (Zod)
│   └── sterilization.ts (Zod)
├── store/
│   └── store.ts (Zustand o Redux)
├── utils/
│   ├── formatters.ts
│   ├── validators.ts
│   └── helpers.ts
└── types/
    └── index.ts (TypeScript types)

components/
├── auth/
│   ├── LoginForm.tsx
│   └── RegisterForm.tsx
├── colonies/
│   ├── ColonyCard.tsx
│   ├── ColonyForm.tsx
│   └── ColonyMap.tsx
├── cats/
│   ├── CatCard.tsx
│   ├── CatForm.tsx
│   └── CatGallery.tsx
├── common/
│   ├── Navbar.tsx
│   ├── Sidebar.tsx
│   ├── Modal.tsx
│   └── LoadingSpinner.tsx
└── reports/
    ├── ReportChart.tsx
    └── ReportExport.tsx
```

### Páginas y Funcionalidades Web

**Autenticación:**
- Login con email/contraseña
- Registro nuevo usuario
- Recuperar contraseña
- Sesión persistente (JWT en cookies)

**Dashboard Principal:**
- Resumen de colonias del usuario
- Estadísticas rápidas (total gatos, esterilizados, nuevos)
- Mapa interactivo con ubicaciones
- Acceso rápido a acciones pendientes

**Gestión de Colonias:**
- Listado con filtros y búsqueda
- Vista detallada con mapa
- Edición de datos
- Invitar colaboradores
- Historial de cambios

**Registro de Gatos:**
- Tabla con todos los gatos de una colonia
- Filtros por estado sanitario
- Upload de fotos
- Edición rápida
- Escaneo de microchip (QR reader)

**Programa CER:**
- Timeline de esterilizaciones
- Programación de citas
- Seguimiento post-operatorio
- Gráficos de progreso

**Reportes:**
- Dashboard de estadísticas
- Exportación a PDF/Excel
- Gráficos interactivos (Chart.js/Recharts)
- Filtros por período y colonia

**Settings:**
- Perfil de usuario
- Cambio de contraseña
- Preferencias de notificación
- Gestión de token API

---

## 8. Mobile (Flutter)

### Estructura del Proyecto

```
lib/
├── main.dart
├── config/
│   ├── routes.dart
│   └── theme.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── colonies/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── cats/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── health/
│   │   ├── screens/
│   │   └── widgets/
│   └── reports/
│       ├── screens/
│       └── widgets/
├── models/
├── services/
│   ├── api_service.dart
│   ├── local_storage.dart
│   └── sync_service.dart
├── shared/
│   ├── widgets/
│   └── constants/
└── utils/
    └── validators.dart
```

### Funcionalidades Mobile

**Optimizaciones móviles:**
- Acceso offline (SQLite local)
- Sincronización automática cuando hay conexión
- Interfaz táctil optimizada
- Cámara integrada para fotos
- GPS para ubicación de colonias
- Notificaciones push

**Pantallas principales:**
- Login/Registro
- Lista de colonias (con mapa)
- Detalle de colonia
- Listado de gatos con fotos
- Registrar nuevo gato (foto + datos)
- Programa CER con timeline
- Historial sanitario
- Reportes básicos (gráficos simples)

**Diferenciales vs Web:**
- Sincronización offline-first
- Notificaciones push de cambios
- Integración cámara y galería
- QR scanner para microchips
- Geolocalización para alertas de área

---

## 9. Seguridad y Validación

### Autenticación

```
POST /auth/login
- Email + contraseña
- Backend valida con Zod
- Si OK: genera JWT (15 min) + Refresh Token (7 días)
- Retorna en httpOnly cookies (web) / Secure storage (mobile)
- Frontend mantiene sesión activa

POST /auth/refresh
- Usa refresh token para obtener nuevo access token
- Automático si access token expira
```

### Validación de Datos

**Zod schemas en backend:**
```typescript
// Ejemplo: Schema de Colonia
const CreateColonySchema = z.object({
  name: z.string().min(3).max(255),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  description: z.string().max(2000).optional(),
});
```

**Zod schemas en frontend:**
- Validación inmediata en formularios
- Mensajes de error en tiempo real
- Previene envío de datos inválidos

### Autorización

**Guards en NestJS:**
```typescript
@UseGuards(AuthGuard) // Verificar JWT
@UseGuards(RoleGuard) // Verificar rol
@UseGuards(OwnershipGuard) // Verificar propiedad
```

**Reglas de acceso:**
- No se puede editar colonia sin ser owner o colaborador
- Municipios solo ven colonias de su ciudad
- No se puede ver datos de otros usuarios sin invitación

### Infraestructura Segura

- HTTPS en todas las conexiones
- JWT en httpOnly cookies (CSRF protection)
- CORS configurado restrictivamente
- Rate limiting en endpoints críticos (login, registros)
- SQL injection prevention (Prisma ORM)
- XSS protection (sanitización Next.js)

---

## 10. Buenas Prácticas de Desarrollo

### Testing

**Unit Tests:**
- Servicios de lógica de negocio
- Helpers y utilidades
- Cobertura objetivo: 80%

**Integration Tests:**
- Endpoints del API
- Flujos completos (login → crear colonia → agregar gato)
- Base de datos de testing

**E2E Tests:**
- Flujos críticos en web y mobile
- Herramientas: Playwright (web), Flutter testing

### Logging y Monitoreo

- Winston para logs en NestJS
- Niveles: error, warn, info, debug
- Sentry para tracking de errores en producción
- Auditoría completa en AuditLog table

### Code Quality

- ESLint + Prettier para formateo
- TypeScript strict mode
- Pre-commit hooks (husky)
- Code review en PRs obligatorios

### CI/CD

- Tests automáticos en cada PR
- Build en staging en cada merge a develop
- Deploy automático a producción con aprobación
- Database migrations versionadas

### Documentación

- Swagger/OpenAPI en `/api/docs`
- JSDoc en funciones complejas
- README con instrucciones de setup
- API docs actualizadas en cada cambio

---

## 11. Consideraciones de Escalabilidad

**Base de datos:**
- Índices en campos frecuentemente consultados
- Particionamiento de tablas grandes (AuditLog) si crece
- Backups automáticos diarios

**Backend:**
- Caching con Redis (colonias populares, reportes)
- Paginación en listados grandes
- Microservicios si crece (reportes, notificaciones)

**Frontend:**
- Code splitting automático (Next.js)
- Lazy loading de imágenes
- Service workers para offline

**Mobile:**
- App bundle optimizado
- Caching de assets
- Sincronización incremental

---

## 12. Roadmap de Implementación

### Fase 1: MVP Core (Sprint 1-3)
- [ ] Autenticación y usuarios
- [ ] CRUD colonias y gatos
- [ ] Seguimiento sanitario básico
- [ ] Web funcional
- [ ] API documentada

### Fase 2: Colaboración y Reportes (Sprint 4-6)
- [ ] Sistema de invitaciones
- [ ] Permisos compartidos
- [ ] Dashboard y reportes
- [ ] Exportación PDF/Excel
- [ ] Mobile versión beta

### Fase 3: CER y Administración (Sprint 7-9)
- [ ] Programa CER completo
- [ ] Dashboard municipal
- [ ] Notificaciones
- [ ] Mobile versión production
- [ ] Optimizaciones offline

### Fase 4: Expansión (Sprint 10+)
- [ ] Integración con municipios (API webhooks)
- [ ] Machine learning para proyecciones
- [ ] Chat en tiempo real
- [ ] Integraciones externas

---

## 13. Métricas de Éxito

- ✅ 100% cobertura de casos de uso descritos
- ✅ API response time < 200ms (P95)
- ✅ 99.5% uptime
- ✅ 0 datos perdidos (auditoría completa)
- ✅ Tests con cobertura > 80%
- ✅ Documentación actualizada

---

**Aprobado por:** Usuario (2026-03-10)
**Siguiente paso:** Crear plan de implementación detallado
