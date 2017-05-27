FROM piwik

# install locales
RUN apt-get update && apt-get install -y \
    locales \
    --no-install-recommends \
    && sed -i 's/# //' /etc/locale.gen \
    && locale-gen

# install phantomjs
RUN apt-get install -y --no-install-recommends \
           ca-certificates \
           bzip2 \
           libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x  \
    # Install official PhantomJS release
    && apt-get install -y --no-install-recommends \
           curl \
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
    && rm -rf /tmp/* /var/lib/apt/lists/*

RUN phantomjs --version
