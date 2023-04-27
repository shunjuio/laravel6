FROM php:7.3-fpm
COPY php.ini /usr/local/etc/php/

RUN apt-get update \
  && apt-get install -y zlib1g-dev libzip-dev mariadb-client \
  && docker-php-ext-install zip pdo_mysql

#Composer install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# rootでのcomposerコマンド実行を許可
ENV COMPOSER_ALLOW_SUPERUSER 1
# composerのグローバルパッケージがインストールされるディレクトリの指定
ENV COMPOSER_HOME /composer
# composerのパスを通す
ENV PATH $PATH:/composer/vendor/bin
# laravelインストール
RUN composer global require "laravel/installer"

RUN curl -SL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install -y nodejs && \
  npm install -g npm@latest && \
  npm install -g @vue/cli

WORKDIR /var/www
