FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

ENV RAILS_ENV=production
RUN set -ex \
    && export BUNDLE_SILENCE_ROOT_WARNING=1 \
    && cd / \
    && apk --update add --virtual .redmine-deps \
         ruby ruby-bundler ruby-bigdecimal ruby-json sqlite-libs tzdata \
    && apk add --virtual .redmine-builddpes \
         curl build-base ruby-dev sqlite-dev zlib-dev \
    && export REDMINE_TAR=https://github.com/redmine/redmine/archive/master.tar.gz \
    && export THEME_ZIP=$(curl --silent https://api.github.com/repos/akabekobeko/redmine-theme-minimalflat2/releases/latest | grep browser_download_url | sed -E 's/.*"([^\"]+)".*/\1/') \
    && curl -sSL $REDMINE_TAR | tar xz \
    && mv redmine-* redmine \
    && cd /redmine \
        && rm files/delete.me log/delete.me \
        && echo "$RAILS_ENV:" > config/database.yml \
        && echo "  adapter: sqlite3" >> config/database.yml \
        && echo "  database: files/redmine.sqlite3" >> config/database.yml \
        && sed -i '/puma/d' Gemfile \
            && echo 'https://www.redmine.org/issues/30074' \
        && echo "gem 'puma'" >> Gemfile.local \
        && echo 'config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))' > config/additional_environment.rb \
        && bundle install --without development test rmagick \
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
