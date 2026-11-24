<?php

declare(strict_types=1);

use App\Greeting;

require dirname(__DIR__) . '/vendor/autoload.php';

echo Greeting::forName($argv[1] ?? '') . PHP_EOL;
