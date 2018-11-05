FROM wordpress:4.9

# Add sudo in order to run wp-cli as the www-data user
RUN apt-get update && apt-get install -y sudo less vim

# Add WP-CLI
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

# Redirect http to https
COPY [".htaccess", "/usr/src/wordpress"]

# Install plugins
ADD "plugins/wp-mail-smtp" "/usr/src/wordpress/wp-content/plugins/wp-mail-smtp"
ADD "plugins/allow-multiple-accounts" "/usr/src/wordpress/wp-content/plugins/allow-multiple-accounts"
ADD "plugins/woocommerce" "/usr/src/wordpress/wp-content/plugins/woocommerce"
ADD "plugins/woo-confirmation-email" "/usr/src/wordpress/wp-content/plugins/wp-confirmation-email"
ADD "plugins/wpforms-lite" "/usr/src/wordpress/wp-content/plugins/wpforms-lite"
ADD "plugins/backupwordpress" "/usr/src/wordpress/wp-content/plugins/backupwordpress"

# Setup SMTP running config.sh
COPY ["apache2-config.sh", "/usr/local/bin/"]

RUN [ "/usr/local/bin/apache2-config.sh" ]
RUN a2enmod headers
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
#WORKDIR /var/www/html/wordpress
WORKDIR /var/www/html

