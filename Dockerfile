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

#  DO NOT include any .env related commands here.
#  Laravel will automatically use environment variables defined in Render.
#  No need to copy .env or set APP_KEY here.

# Expose port 8000 (default for artisan serve)
EXPOSE 8000

# Start the artisan serve command
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
