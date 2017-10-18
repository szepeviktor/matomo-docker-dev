FROM piwik

# install git + other deps
RUN apt-get update && \
    apt-get install software-properties-common python-software-properties php-pear git wget curl \
                    tcl tk openssl mysql-client -y --no-install-recommends

# install locales
RUN apt-get install -y \
    locales \
    --no-install-recommends \
    && sed -i 's/# \(.*de_\)/\1/' /etc/locale.gen \
    && sed -i 's/# \(.*en_\)/\1/' /etc/locale.gen \
    && sed -i 's/# \(.*fr_\)/\1/' /etc/locale.gen \
    && locale-gen

RUN apt-get install -y --no-install-recommends \
           ca-certificates \
           bzip2 \
           libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install phantomjs, dumb-init (to handle PID 1 correctly) https://github.com/Yelp/dumb-init
RUN set -x  \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
    && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb \
    && dpkg -i /tmp/dumb-init.deb \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && phantomjs --version

# install extensions
RUN docker-php-ext-install mysqli
RUN pecl install redis

# install python for log importer
RUN apt-get install python2.7 \
    && curl -L https://bootstrap.pypa.io/get-pip.py | python

# install ssmtp
RUN apt-get update \
    && apt-get install -y ssmtp \
    && apt-get clean \
    && echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
