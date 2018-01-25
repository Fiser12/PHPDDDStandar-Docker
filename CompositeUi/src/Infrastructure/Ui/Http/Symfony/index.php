<?php

/*
 * This file is part of the Php DDD Standard project.
 *
 * Copyright (c) 2017-present LIN3S <info@lin3s.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

declare(strict_types=1);

use CompositeUi\Infrastructure\Symfony\Framework\Kernel;
use Symfony\Component\Debug\Debug;
use Symfony\Component\Dotenv\Dotenv;
use Symfony\Component\HttpFoundation\Request;

require_once __DIR__ . '/../../../../../vendor/autoload.php';

if (!isset($_SERVER['APP_ENV'])) {
    if (!class_exists(Dotenv::class)) {
        throw new \RuntimeException(
            'ENV environment variable is not defined. You need to define environment variables for ' .
            'configuration or add "symfony/dotenv" as a Composer dependency to load variables from a .env file.'
        );
    }
    (new Dotenv())->load(__DIR__ . '/../../../../../.env');
}

if ($_SERVER['APP_DEBUG'] ?? ('prod' !== ($_SERVER['APP_ENV'] ?? 'dev'))) {
    umask(0000);

    Debug::enable();
}

$request = Request::createFromGlobals();
$kernel = new Kernel($_SERVER['APP_ENV'] ?? 'dev', $_SERVER['APP_DEBUG'] ?? ('prod' !== ($_SERVER['APP_ENV'] ?? 'dev')));
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
