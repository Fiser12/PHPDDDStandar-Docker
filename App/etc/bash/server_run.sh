#!/usr/bin/env bash

# This file is part of the Php DDD Standard project.
#
# Copyright (c) 2017-present LIN3S <info@lin3s.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
# @author Beñat Espiña <benatespina@gmail.com>
# @author Gorka Laucirica <gorka.lauzirika@gmail.com>

$(dirname $0)/../bin/symfony-console server:run 127.0.0.1:8002 \
    --docroot=src/App/Infrastructure/Ui/Http/Symfony \
