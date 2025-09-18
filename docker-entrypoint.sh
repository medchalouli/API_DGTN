#!/bin/bash

# Exit on any error
set -e

echo "Starting Django application setup..."

# Wait for database to be ready
echo "Waiting for database..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "Database is ready!"

# Create virtual environment as specified in README.md
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python -m venv .venv --prompt="Med_Virtual"
fi

# Activate virtual environment
source .venv/bin/activate

# Install requirements if not already installed
echo "Installing requirements..."
pip install -r requirements.txt

# Run Django management commands as specified in README.md
echo "Making migrations..."
python manage.py makemigrations

echo "Running migrations..."
python manage.py migrate

echo "Collecting static files..."
python manage.py collectstatic --no-input

# Create superuser if it doesn't exist (optional, for development)
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

echo "Django setup complete!"

# Execute the main command
exec "$@"