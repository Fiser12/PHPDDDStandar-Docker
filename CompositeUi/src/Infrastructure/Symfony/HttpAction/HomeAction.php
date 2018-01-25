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

namespace CompositeUi\Infrastructure\Symfony\HttpAction;

use Symfony\Component\HttpFoundation\Response;

class HomeAction
{
    private $twig;

    public function __construct(\Twig_Environment $twig)
    {
        $this->twig = $twig;
    }

    public function __invoke() : Response
    {
        return new Response(
            $this->twig->render('pages/home.html.twig')
        );
    }
}
