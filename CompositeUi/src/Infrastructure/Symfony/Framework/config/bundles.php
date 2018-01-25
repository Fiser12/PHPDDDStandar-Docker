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

return [
    SmartCore\Bundle\AcceleratorCacheBundle\AcceleratorCacheBundle::class => ['all' => true],
    LIN3S\Distribution\Php\Symfony\Lin3sDistributionBundle::class         => ['all' => true],
    Symfony\Bundle\FrameworkBundle\FrameworkBundle::class                 => ['all' => true],
    Symfony\Bundle\MonologBundle\MonologBundle::class                     => ['all' => true],
    Symfony\Bundle\TwigBundle\TwigBundle::class                           => ['all' => true],
    Symfony\Bundle\WebServerBundle\WebServerBundle::class                 => ['dev' => true],
];
