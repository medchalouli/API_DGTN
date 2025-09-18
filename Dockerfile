# Use AlmaLinux as base image
FROM almalinux:8

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=app_dgtn.settings

# Set work directory
WORKDIR /app

# Install system dependencies following README.md instructions
RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf install -y python3.11 python3.11-pip python3.11-devel && \
    dnf install -y postgresql postgresql-devel gcc && \
    dnf install -y nano screen httpd python3.11-mod_wsgi && \
    dnf clean all

# Create symbolic link for python as specified in README.md
RUN ln -sf /usr/bin/python3.11 /usr/bin/python

# Upgrade pip as specified in README.md
RUN python -m pip install --upgrade pip

# Copy requirements file first for better Docker layer caching
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy project files
COPY . /app/

# Create media directory with proper permissions
RUN mkdir -p /app/media/product_pictures && \
    chmod -R 755 /app/media

# Create static files directory
RUN mkdir -p /app/static

# Set proper permissions for the application
RUN chmod -R 755 /app

# Expose port 8000
EXPOSE 8000

# Copy entrypoint script
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Default command
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]