FROM php:8.2-fpm-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache --update libzip-dev zip postgresql-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /app

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate application key
RUN php artisan key:generate --ansi

# Set proper permissions
RUN chown -R www-data:www-data /app
RUN chmod -R 775 /app/storage /app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Serve the application with PHP-FPM and Nginx
CMD ["php-fpm"]
