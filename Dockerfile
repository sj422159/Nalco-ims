FROM php:8.2-fpm-alpine # Or your preferred PHP version

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache --update libzip-dev zip

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /app

# Set application permissions
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 755 /app/bootstrap/cache /app/storage

# Expose port (though Render handles this)
EXPOSE 9000

# Command to start PHP-FPM
CMD ["php-fpm"]