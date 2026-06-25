# Alexandria Community Mobility Platform

A community-based scheduled transportation platform for Alexandria, Egypt.

## Tech Stack

### Backend
- ASP.NET Core 8 Web API
- Clean Architecture (Domain / Application / Infrastructure / Presentation)
- Entity Framework Core + SQL Server
- ASP.NET Core Identity (JWT + Refresh Tokens)
- SignalR (real-time tracking)
- Redis (caching)
- Hangfire (background jobs)
- Serilog (structured logging)
- FluentValidation
- AutoMapper

### Frontend
- Angular 19 (standalone components)
- TypeScript
- SCSS
- SignalR Client
- RxJS

### DevOps
- Docker + Docker Compose
- GitHub Actions CI/CD

## Getting Started

### Prerequisites
- .NET 8 SDK
- Node.js 20+
- Docker & Docker Compose
- SQL Server (or use Docker)

### Quick Start with Docker

```bash
docker-compose up -d
```

- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger
- Frontend: http://localhost:4200
- Hangfire: http://localhost:5000/hangfire

### Manual Setup

**Backend:**
```bash
cd backend
dotnet restore
dotnet build
dotnet run --project src/AlexandriaMobilityPlatform.API
```

**Frontend:**
```bash
cd web
npm install
ng serve
```

### Default Roles
- SuperAdmin
- CommunityAdmin
- Driver
- Passenger

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/register | Register new user |
| POST | /api/auth/login | Login |
| POST | /api/auth/refresh-token | Refresh JWT |
| GET | /api/communities | List communities |
| GET | /api/communities/{id} | Community details |
| POST | /api/communities/join | Join community |
| GET | /api/groups/community/{id} | List groups |
| GET | /api/groups/search | Search groups |
| POST | /api/bookings | Create booking |
| GET | /api/bookings/my | My bookings |
| GET | /api/dashboard/super-admin | Admin analytics |
| GET | /api/notifications | User notifications |

## Project Structure

```
AlexMove/
├── backend/
│   └── src/
│       ├── AlexandriaMobilityPlatform.Domain/       # Entities, Enums
│       ├── AlexandriaMobilityPlatform.Application/  # DTOs, Services, Interfaces
│       ├── AlexandriaMobilityPlatform.Infrastructure/ # EF Core, Repositories
│       └── AlexandriaMobilityPlatform.API/          # Controllers, Middleware
├── web/                                              # Angular 19 Frontend
├── docs/                                             # Architecture & DB docs
├── docker-compose.yml
└── .github/workflows/ci.yml
```

## License
Proprietary - Alexandria Community Mobility Platform
