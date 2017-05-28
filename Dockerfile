FROM piwik

# install locales
RUN apt-get update && apt-get install -y \
    locales \
    --no-install-recommends \
    && sed -i 's/# //' /etc/locale.gen \
    && locale-gen

# install git + other deps
RUN apt-get install php-pear git wget curl tcl tk -y --no-install-recommends

# install phantomjs
RUN apt-get install -y --no-install-recommends \
           ca-certificates \
           bzip2 \
           libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x  \
    # Install official PhantomJS release
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
       # Install dumb-init (to handle PID 1 correctly).
       # https://github.com/Yelp/dumb-init
    && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb \
    && dpkg -i /tmp/dumb-init.deb \
       # Clean up
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && phantomjs --version

# install extensions
RUN docker-php-ext-install mysqli
RUN pecl install redis

# install python for log importer
ENV PYTHON_GPG_KEY C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
ENV PYTHON_VERSION 2.7.13

RUN set -ex \
  && buildDeps=' \
    dpkg-dev \
    tcl-dev \
    tk-dev \
  ' \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  \
  && wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
  && wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$PYTHON_GPG_KEY" \
  && gpg --batch --verify python.tar.xz.asc python.tar.xz \
  && rm -r "$GNUPGHOME" python.tar.xz.asc \
  && mkdir -p /usr/src/python \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz \
  \
  && cd /usr/src/python \
  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && ./configure \
    --build="$gnuArch" \
    --enable-shared \
    --enable-unicode=ucs4 \
  && make -j "$(nproc)" \
  && make install \
  && ldconfig \
  \
  && apt-get purge -y --auto-remove $buildDeps \
  \
  && find /usr/local -depth \
    \( \
      \( -type d -a -name test -o -name tests \) \
      -o \
      \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    \) -exec rm -rf '{}' + \
  && rm -rf /usr/src/python
