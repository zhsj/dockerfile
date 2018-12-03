#!/bin/sh
set -e

case "$1" in
    rails|rake)
        if [ ! -f './config/configuration.yml' ]; then
            if [ "$EMAIL_USER" ]; then
                cat > './config/configuration.yml' <<-YML
					$RAILS_ENV:
					  email_delivery:
					    delivery_method: :smtp
					    smtp_settings:
					      enable_starttls_auto: true
					      address: "$EMAIL_SMTP"
					      port: "${SMTP_PORT:-587}"
					      domain: "$EMAIL_DOMAIN"
					      authentication: :plain
					      user_name: "$EMAIL_USER"
					      password: "$EMAIL_PASSWORD"
					YML
            fi
        fi

        if [ ! -f ./config/initializers/secret_token.rb ]; then
            rake generate_secret_token
        fi

        if [ "$1" != 'rake' ] && [ -z "$REDMINE_NO_DB_MIGRATE" ]; then
            gosu redmine rake db:migrate
        fi

        chown -R redmine:redmine ./files

        # remove PID file to enable restarting the container
        rm -f ./tmp/pids/server.pid

        set -- gosu redmine "$@"
        ;;
esac

exec "$@"
