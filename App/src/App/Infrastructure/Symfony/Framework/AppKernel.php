<?php

/*
 * This file is part of the Php DDD Standard project.
 *
 * Copyright (c) 2017-present-present LIN3S <info@lin3s.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

declare(strict_types=1);

namespace App\Infrastructure\Symfony\Framework;

use Doctrine\Bundle\DoctrineBundle\DoctrineBundle;
use Doctrine\Bundle\MigrationsBundle\DoctrineMigrationsBundle;
use LIN3S\Distribution\Php\Symfony\Lin3sDistributionBundle;
use Sensio\Bundle\DistributionBundle\SensioDistributionBundle;
use Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle;
use SmartCore\Bundle\AcceleratorCacheBundle\AcceleratorCacheBundle;
use Symfony\Bundle\DebugBundle\DebugBundle;
use Symfony\Bundle\FrameworkBundle\FrameworkBundle;
use Symfony\Bundle\MonologBundle\MonologBundle;
use Symfony\Bundle\SecurityBundle\SecurityBundle;
use Symfony\Bundle\SwiftmailerBundle\SwiftmailerBundle;
use Symfony\Bundle\TwigBundle\TwigBundle;
use Symfony\Bundle\WebProfilerBundle\WebProfilerBundle;
use Symfony\Bundle\WebServerBundle\WebServerBundle;
use Symfony\Component\Config\Loader\LoaderInterface;
use Symfony\Component\HttpKernel\Kernel;

class AppKernel extends Kernel
{
    public function registerBundles() : array
    {
        $bundles = [
            new AcceleratorCacheBundle(),
            new DoctrineMigrationsBundle(),
            new DoctrineBundle(),
            new FrameworkBundle(),
            new Lin3sDistributionBundle(),
            new MonologBundle(),
            new SecurityBundle(),
            new SensioFrameworkExtraBundle(),
            new SwiftmailerBundle(),
            new TwigBundle(),
        ];

        if (in_array($this->getEnvironment(), ['dev', 'test'], true)) {
            $bundles[] = new DebugBundle();
            $bundles[] = new WebProfilerBundle();
            $bundles[] = new SensioDistributionBundle();

            if ('dev' === $this->getEnvironment()) {
                $bundles[] = new WebServerBundle();
            }
        }

        return $bundles;
    }

    public function getRootDir() : string
    {
        return __DIR__;
    }

    public function getCacheDir() : string
    {
        return dirname(__DIR__) . '/../../../../var/cache/' . $this->getEnvironment();
    }

    public function getLogDir() : string
    {
        return dirname(__DIR__) . '/../../../../var/logs';
    }

    public function registerContainerConfiguration(LoaderInterface $loader) : void
    {
        $loader->load($this->getRootDir() . '/config/config_' . $this->getEnvironment() . '.yml');
    }
}
