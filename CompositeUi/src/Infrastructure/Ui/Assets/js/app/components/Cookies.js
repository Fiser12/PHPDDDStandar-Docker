/*
 * This file is part of the Php DDD Standard project.
 *
 * Copyright (c) 2017-present LIN3S <info@lin3s.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Beñat Espiña <benatespina@gmail.com>
 */

import {onDomReady} from 'lin3s-event-bus';
import {BenGorCookies} from 'bengor-cookies';

const onReady = () => {
  new BenGorCookies({
    triggers: 'html',
    maxPageYOffset: 200
  });
};

onDomReady(onReady);
