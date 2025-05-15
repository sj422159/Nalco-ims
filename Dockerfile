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

# Set proper permissions to avoid running Composer as root
RUN chown -R www-data:www-data /app
USER www-data

# Load environment variables
RUN if [ -f .env ]; then \
      cp .env .env.prod; \
      php -r "require '/app/vendor/autoload.php'; (new Dotenv\Dotenv('/app'))->load();"; \
    fi

# Install Composer dependencies without scripts
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Generate application key
RUN php artisan key:generate --ansi

# Run database migrations
RUN php artisan migrate --force

# Clear cache
RUN php artisan cache:clear
RUN php artisan config:cache
RUN php artisan view:clear
RUN php artisan route:clear

# Set proper permissions (again, after migrations)
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 775 /app/storage /app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Serve the application with PHP-FPM and Nginx
CMD ["php-fpm"]
