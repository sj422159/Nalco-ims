FROM php:8.2-cli-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache --update libzip-dev zip postgresql-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /app

# Set proper permissions to avoid running Composer as root
RUN chown -R www-data:www-data /app
USER www-data

# Install Composer dependencies (without --no-scripts)
RUN composer install 

# Generate application key
RUN php artisan key:generate --ansi

# Expose port 8000 (default for artisan serve)
EXPOSE 8000

# Start the application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
