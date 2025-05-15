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

# Set proper permissions and user
RUN chown -R www-data:www-data /app
USER www-data

# Copy .env file
COPY .env .env

# Load environment variables and install dependencies
RUN php -r "require '/app/vendor/autoload.php'; \$dotenv = Dotenv\Dotenv::createImmutable('/app'); \$dotenv->load();" \
    && composer install --no-dev --optimize-autoloader \
    && php artisan key:generate --ansi

# Run database migrations
RUN php artisan migrate --force

# Clear cache
RUN php artisan cache:clear \
    && php artisan config:cache \
    && php artisan view:clear \
    && php artisan route:clear

# Set proper permissions (again, after migrations)
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 775 /app/storage /app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Serve the application with PHP-FPM and Nginx
CMD ["php-fpm"]
