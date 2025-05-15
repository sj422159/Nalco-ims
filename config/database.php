

'pgsql' => [
    'driver' => 'pgsql',
    'url' => env('DATABASE_URL'),
    'host' => env('DB_HOST', '127.0.0.1'), // Use the DB_HOST environment variable
    'port' => env('DB_PORT', '5432'),     // Use the DB_PORT environment variable
    'database' => env('DB_DATABASE', 'ims_g3yl'), // Use the DB_DATABASE environment variable
    'username' => env('DB_USERNAME', 'root'), // Use the DB_USERNAME environment variable
    'password' => env('DB_PASSWORD', ''),     // Use the DB_PASSWORD environment variable
    'charset' => 'utf8',
    'prefix' => '',
    'prefix_indexes' => true,
    'search_path' => 'public',
    'sslmode' => 'prefer',
],
