FROM php:7-cli
# FROM  debian:jessie

MAINTAINER Yo-An Lin "yoanlin93@gmail.com"

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_VERSION 7
ENV PHPBREW_ROOT /root/.phpbrew
ENV PHPBREW_HOME /root/.phpbrew
ENV PHPBREW_SET_PROMPT 1


# Remove default dash and replace it with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN export DEBIAN_FRONTEND="noninteractive" \
  && apt-get update \
  && apt-get -qqy install autoconf automake curl build-essential libxslt1-dev re2c libxml2 libxml2-dev bison libbz2-dev libreadline-dev \
                          libfreetype6 libfreetype6-dev libpng-dev libjpeg-dev libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev \
                          libssl-dev openssl gettext libgettextpo-dev libgettextpo0 \
                          libicu-dev libmhash-dev libmhash2 libmcrypt-dev libmcrypt4 \
                          mysql-client default-libmysqlclient-dev \
                          ca-certificates libyaml-dev libyaml-0-2 \
                          libcurl4-gnutls-dev libexpat1-dev libz-dev librecode0 \
                          libpcre3-dev libpcre++-dev git wget curl sqlite3 \
  && apt-get clean -y \
  && apt-get autoclean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /var/lib/apt/lists/*

# Install php tools
RUN mkdir -p /usr/bin \
  && wget -q -O /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit \
  && wget -q -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer \
  && wget -q -O /usr/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar && chmod +x /usr/bin/phpmd \
  && wget -q -O /usr/bin/sami http://get.sensiolabs.org/sami.phar && chmod +x /usr/bin/sami \
  && wget -q -O /usr/bin/phpcov https://phar.phpunit.de/phpcov.phar && chmod +x /usr/bin/phpcov \
  && wget -q -O /usr/bin/phpcpd https://phar.phpunit.de/phpcpd.phar && chmod +x /usr/bin/phpcpd \
  && wget -q -O /usr/bin/phploc https://phar.phpunit.de/phploc.phar && chmod +x /usr/bin/phploc \
  && wget -q -O /usr/bin/phptok https://phar.phpunit.de/phptok.phar && chmod +x /usr/bin/phptok \
  && wget -q -O /usr/bin/box https://github.com/box-project/box2/releases/download/2.5.2/box-2.5.2.phar && chmod +x /usr/bin/box \
  && wget -q -O /usr/bin/phpbrew https://github.com/phpbrew/phpbrew/raw/master/phpbrew && chmod +x /usr/bin/phpbrew

RUN phpbrew init \
  && echo 'source $HOME/.phpbrew/bashrc' >> /root/.bashrc

COPY php.ini /root/php.ini

WORKDIR /root

COPY build.sh /root/build.sh
CMD ["/root/build.sh"]
ENTRYPOINT ["/root/build.sh"]