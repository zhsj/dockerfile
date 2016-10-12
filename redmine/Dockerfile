# Fork from serverbee/redmine-alpine
FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export REDMINE_VERSION=3.3.1 \
    && export GOSU_VERSION=1.10 \
    && export THEME_VERSION=v1.2.1
    && export REDMINE_TAR=https://github.com/redmine/redmine/archive/"$REDMINE_VERSION".tar.gz \
    && export THEME_ZIP=https://github.com/akabekobeko/redmine-theme-minimalflat2/releases/download/"$THEME_VERSION"/minimalflat2-"$THEME_VERSION".zip
    && export GOSU_BIN=https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-amd64 \
    && export RAILS_ENV=production \
    && export BUNDLE_SILENCE_ROOT_WARNING=1 \
    && cd / \
    && apk --update add --virtual .redmine-deps \
         ruby ruby-bundler ruby-bigdecimal sqlite-libs tzdata git \
    && apk add --virtual .redmine-builddpes \
         curl build-base ruby-dev sqlite-dev zlib-dev \
    && curl -sSL $GOSU_BIN -o /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && curl -sSL $REDMINE_TAR | tar xz \
    && mv redmine-$REDMINE_VERSION redmine \
    && cd /redmine \
    && rm files/delete.me log/delete.me \
    && echo "$RAILS_ENV:" > config/database.yml \
    && echo "  adapter: sqlite3" >> config/database.yml \
    && echo "  database: files/redmine.sqlite3" >> config/database.yml \
    && bundle install --without development test rmagick \
    && cd public/themes/ \
        && curl -sSL $THEME_ZIP -o minimalflat2.zip \
        && unzip minimalflat2.zip \
        && rm minimalflat2.zip \
    && rm -rf ~/.bundle/ \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
    && apk --purge del .redmine-builddpes \
    && rm -rf /var/cache/apk/* \
    && adduser -h ${PWD} -D -H -s /sbin/nologin redmine \
    && chown -R redmine:redmine /redmine

WORKDIR /redmine

VOLUME ["/redmine/files", "/gitrepo"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
