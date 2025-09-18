# API DGTN - Docker Setup

This Docker setup implements the deployment instructions from the main README.md using AlmaLinux as the base image.

## Quick Start

1. **Build and run the application:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - Django API: http://localhost:8000
   - Nginx reverse proxy: http://localhost:80
   - Admin interface: http://localhost:8000/admin (admin/admin)

## Services

### Web Application (Django)
- Built on AlmaLinux 8
- Python 3.11 (as specified in README.md)
- Django with DRF API
- Automatic migrations and static file collection

### Database (PostgreSQL)
- PostgreSQL 13
- Database name: `dgtn`
- User: `postgres`
- Password: `dgtn@2025`
- (As configured in the original README.md)

### Reverse Proxy (Nginx)
- Serves static and media files
- Proxies API requests to Django
- Configured with CORS headers

## Commands

### Development
```bash
# Build and start services
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Database Management
```bash
# Access PostgreSQL shell
docker-compose exec db psql -U postgres -d dgtn

# Run Django management commands
docker-compose exec web python manage.py shell
docker-compose exec web python manage.py createsuperuser
```

### Production Deployment
```bash
# For production, set DEBUG=0 in docker-compose.yml
# Update ALLOWED_HOSTS in settings.py
# Use a proper secret key
```

## File Structure
```
.
├── Dockerfile              # AlmaLinux-based Django container
├── docker-compose.yml      # Multi-service orchestration
├── docker-entrypoint.sh    # Startup script following README.md steps
├── nginx.conf              # Nginx configuration with CORS
├── requirements.txt        # Python dependencies
└── .dockerignore           # Docker build exclusions
```

## Environment Variables

The application supports the following environment variables:

- `DATABASE_URL`: Complete database URL (optional)
- `POSTGRES_DB`: Database name (default: dgtn)
- `POSTGRES_USER`: Database user (default: postgres)
- `POSTGRES_PASSWORD`: Database password (default: dgtn@2025)
- `POSTGRES_HOST`: Database host (default: db)
- `POSTGRES_PORT`: Database port (default: 5432)
- `DEBUG`: Django debug mode (default: 1)

## Notes

- The setup follows the exact commands and configurations from the main README.md
- Virtual environment is created inside the container as specified
- PostgreSQL database is configured with the same credentials as the README.md
- Static files and media files are properly handled
- CORS is configured as specified in the Apache configuration example