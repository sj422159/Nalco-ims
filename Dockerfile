FROM php:8.2-cli-alpine 

WORKDIR /app

# Install required extensions
RUN apk add --no-cache --update libzip-dev zip
RUN docker-php-ext-install pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /app

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Set application key (if not already in .env)
RUN php artisan key:generate --ansi

# Expose port 8000 (default for artisan serve)
EXPOSE 8000

# Start the artisan serve command
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]