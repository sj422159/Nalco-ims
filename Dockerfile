FROM php:8.2-fpm-alpine 

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache --update libzip-dev zip nginx

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /app

# Set application permissions
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache
RUN chmod -R 755 /app/bootstrap/cache /app/storage

# Configure Nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for HTTP
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["/bin/sh", "-c", "nginx -g 'daemon off;' & php-fpm"]