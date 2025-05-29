# Use official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements file first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY . .

# Set environment variables from .env manually
ENV ENVIRONMENT=DEV \
    HOST=0.0.0.0 \
    PORT=8000 \
    REDIS_HOST=redis \
    REDIS_PORT=6379 \
    REDIS_DB=0

# Expose the port the app runs on
EXPOSE 8000

# Start the app
CMD ["python", "hello.py"]
