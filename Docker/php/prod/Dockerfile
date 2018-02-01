FROM php:7.1-fpm

#NODE ENVIRONMENT PREPARED
RUN set -ex \
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done

#NODE INSTALATION
ENV NODE_VERSION 9.4.0

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

#YARN INSTALLATION
ENV YARN_VERSION 1.3.2

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz


RUN apt-get update \
	&& apt-get install -y \
		zip \
		unzip \
		vim \
		wget \
		curl \
		git \
		mysql-client \
		moreutils \
		dnsutils \
		zlib1g-dev \
		libicu-dev \
		libmemcached-dev \
		g++ \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set your timezone here
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN "date"

# Run docker-php-ext-install for available extensions
RUN docker-php-ext-configure intl \
    && docker-php-ext-install pdo pdo_mysql opcache intl

ADD . /app
RUN chown -R www-data:www-data /app

RUN chmod -R 777 /app
RUN composer install -d=/app/App --no-dev --no-interaction
RUN composer install -d=/app/CompositeUi --no-dev --no-interaction
RUN (cd /app/CompositeUi/src/Infrastructure/Ui/Assets && yarn install)
RUN (cd /app/CompositeUi/src/Infrastructure/Ui/Assets && yarn build:prod)

CMD sed \
        -e "s/\${database_host}/${DB_HOST}/" \
        -e "s/\${database_port}/${DB_PORT}/" \
        -e "s/\${database_name}/${DB_DATABASE}/" \
        -e "s/\${database_user}/${DB_ROOT}/" \
        -e "s/\${database_password}/${MYSQL_ROOT_PASSWORD}/" \
        -e "s/\${database_server_version}/${MYSQL_DATABASE_SERVER_VERSION}/" \
        -e "s/\${mailer_transport}/${MAILER_TRANSPORT}/" \
        -e "s/\${mailer_host}/${MAILER_HOST}/" \
        -e "s/\${mailer_user}/${MAILER_USER}/" \
        -e "s/\${mailer_password}/${MAILER_PASSWORD}/" \
        -e "s/\${mail_delivery_address}/${MAILER_DELIVERY_ADDRESS}/" \
        -e "s/\${router_request_context_host}/${REQUEST_CONTEXT_HOST}/" \
        -e "s/\${router_request_context_scheme}/${REQUEST_CONTEXT_SCHEME}/" \
        -e "s/\${secret-app}/${SECRET_KEY_APP}/" \
        -e "s/\${secret-compositeui}/${SECRET_KEY_COMPOSITE_UI}/" \
        -e "s/\${env}/prod/" \
        /app/Docker/php/app-parameters.yml.dist > /app/App/parameters.yml  && \
    sed \
        -e "s/\${database_host}/${DB_HOST}/" \
        -e "s/\${database_port}/${DB_PORT}/" \
        -e "s/\${database_name}/${DB_DATABASE}/" \
        -e "s/\${database_user}/${DB_ROOT}/" \
        -e "s/\${database_password}/${MYSQL_ROOT_PASSWORD}/" \
        -e "s/\${database_server_version}/${MYSQL_DATABASE_SERVER_VERSION}/" \
        -e "s/\${mailer_transport}/${MAILER_TRANSPORT}/" \
        -e "s/\${mailer_host}/${MAILER_HOST}/" \
        -e "s/\${mailer_user}/${MAILER_USER}/" \
        -e "s/\${mailer_password}/${MAILER_PASSWORD}/" \
        -e "s/\${mail_delivery_address}/${MAILER_DELIVERY_ADDRESS}/" \
        -e "s/\${router_request_context_host}/${REQUEST_CONTEXT_HOST}/" \
        -e "s/\${router_request_context_scheme}/${REQUEST_CONTEXT_SCHEME}/" \
        -e "s/\${secret-app}/${SECRET_KEY_APP}/" \
        -e "s/\${secret-compositeui}/${SECRET_KEY_COMPOSITE_UI}/" \
        -e "s/\${env}/prod/" \
        /app/Docker/php/.compositeui-env.dist > /app/CompositeUi/.env && \
        php /app/App/etc/bin/symfony-console doctrine:database:create --if-not-exists && \
        php /app/App/etc/bin/symfony-console do:mi:mi -v --no-interaction --allow-no-migration && \
        php-fpm -F