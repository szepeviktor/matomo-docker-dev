#!/bin/bash
set -e

export PHPBREW_SET_PROMPT=1
source /root/.phpbrew/bashrc

PHP_SUBVERSION="$1"

if ! [[ "$PHP_SUBVERSION" =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
    phpbrew $@
    exit $?
fi

phpbrew install $PHP_SUBVERSION \
  +default +bcmath +bz2 +calendar +cli +ctype +dom +fileinfo +filter +json \
  +mbregex +mbstring +mhash +pcntl +pcre +pdo +phar +posix +readline +sockets \
  +tokenizer +xml +curl +zip +openssl=yes +icu +opcache +fpm +sqlite +mysql +icu +default +intl +gettext

phpbrew use $PHP_SUBVERSION

echo "installing yaml..."
phpbrew ext install yaml -- --with-yaml=/usr/lib/x86_64-linux-gnu

echo "installing gd..."
phpbrew ext install gd -- --with-png-dir=/opt/local --with-jpeg-dir=/opt/local --with-freetype-dir=/opt/local --enable-gd-native-ttf

echo "installing xdebug..."
phpbrew ext install xdebug latest

echo "installing apcu..."
phpbrew ext install apcu latest

cp /root/php.ini $PHPBREW_ROOT/php/php-$PHP_SUBVERSION/etc/php.ini

php -v
