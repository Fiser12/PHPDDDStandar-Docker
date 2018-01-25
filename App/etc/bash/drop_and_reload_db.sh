#!/usr/bin/env bash

# This file is part of the Php DDD Standard project.
#
# Copyright (c) 2017-present LIN3S <info@lin3s.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
# @author Beñat Espiña <benatespina@gmail.com>

$(dirname $0)/../bin/symfony-console doctrine:database:drop --force
$(dirname $0)/../bin/symfony-console doctrine:database:create
$(dirname $0)/../bin/symfony-console doctrine:migrations:migrate --no-interaction
