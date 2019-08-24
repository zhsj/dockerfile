FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

ENV RAILS_ENV=production
RUN set -ex \
    && export BUNDLE_SILENCE_ROOT_WARNING=1 \
    && export REDMINE_VER=4.0.4 \
    && cd / \
    && apk --update add --virtual .redmine-deps \
         ruby ruby-bundler ruby-bigdecimal ruby-json sqlite-libs tzdata mariadb-connector-c \
    && apk add --virtual .redmine-builddpes \
         curl build-base ruby-dev sqlite-dev zlib-dev mariadb-connector-c-dev \
    && export REDMINE_TAR=https://www.redmine.org/releases/redmine-"$REDMINE_VER".tar.gz \
    && export THEME_ZIP=$(curl --silent https://api.github.com/repos/akabekobeko/redmine-theme-minimalflat2/releases/latest | grep browser_download_url | sed -E 's/.*"([^\"]+)".*/\1/') \
    && curl -sSL $REDMINE_TAR | tar xz \
    && mv redmine-* redmine \
    && cd /redmine \
        && rm files/delete.me log/delete.me \
        && echo "$RAILS_ENV:" > config/database.yml \
        && echo "  adapter: mysql2" >> config/database.yml \
        && sed -i '/puma/d' Gemfile \
            && echo 'https://www.redmine.org/issues/30074' \
        && echo "gem 'puma'" >> Gemfile.local \
        && echo 'config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))' > config/additional_environment.rb \
        && bundle install --without development test rmagick \
        && rm -rf config/database.yml \
        && cd public/themes/ \
            && curl -sSL $THEME_ZIP -o minimalflat2.zip \
            && unzip minimalflat2.zip \
            && rm minimalflat2.zip \
    && rm -rf ~/.bundle/ \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
    && apk --purge del .redmine-builddpes \
    && rm -rf /var/cache/apk/* \
    && adduser -h /redmine -s /sbin/nologin -u 1000 -D -H redmine \
    && chown -R redmine:redmine /redmine

USER 1000:1000

WORKDIR /redmine

VOLUME ["/redmine/files"]

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
