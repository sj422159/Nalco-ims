<?php

use Symfony\Component\Dotenv\Dotenv;

// Load environment variables
$dotenv = new Dotenv();
$dotenv->load(__DIR__.'/../.env'); // Adjust the path if necessary

$defaultConnection = getenv('DATABASE_URL') ? 'default' : (getenv('APP_ENV') === 'test' ? 'test' : 'pgsql');

return [
    'default' => getenv('APP_ENV') === 'test' ? 'test' : $defaultConnection, // Set the default connection

    'connections' => [
        'default' => [
            'url' => getenv('DATABASE_URL'),
            'driver' => 'pdo_pgsql', // Use pdo_pgsql
            'server_version' => '13', // Or your PostgreSQL version on Render
            'charset' => 'utf8',
            'default_table_collation' => 'utf8_general_ci',
        ],

        'pgsql' => [
            'driver' => 'pdo_pgsql',
            'server_version' => '13', // Or your PostgreSQL version on Render
            'host' => getenv('DB_HOST'),
            'port' => getenv('DB_PORT', '5432'),
            'dbname' => getenv('DB_DATABASE'),
            'user' => getenv('DB_USERNAME'),
            'password' => getenv('DB_PASSWORD'),
            'charset' => 'utf8',
            'default_table_collation' => 'utf8_general_ci',
        ],
       'test' => [
            'driver' => 'pdo_sqlite',
            'path' => ':memory:',
            'memory' => true,
        ],
    ],
];
