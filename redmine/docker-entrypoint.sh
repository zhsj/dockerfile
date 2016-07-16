#!/bin/sh
set -e

case "$1" in
    rails|rake)
        if [ ! -f './config/configuration.yml' ]; then
            if [ "$EMAIL_USER" ]; then
                username="${EMAIL_USER}"
                password="${EMAIL_PASSWORD}"
                domain="${EMAIL_DOMAIN}"
                smtp="${EMAIL_SMTP}"

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

        if [ ! -s config/secrets.yml ]; then
            if [ "$REDMINE_SECRET_KEY_BASE" ]; then
                cat > 'config/secrets.yml' <<-YML
					$RAILS_ENV:
					  secret_key_base: "$REDMINE_SECRET_KEY_BASE"
					YML
            elif [ ! -f /redmine/config/initializers/secret_token.rb ]; then
                rake generate_secret_token
            fi
        fi
        if [ "$1" != 'rake' -a -z "$REDMINE_NO_DB_MIGRATE" ]; then
            gosu redmine rake db:migrate
        fi

        chown -R redmine:redmine files log public/plugin_assets

        # remove PID file to enable restarting the container
        rm -f /redmine/tmp/pids/server.pid

        set -- gosu redmine "$@"
        ;;
esac

exec "$@"
