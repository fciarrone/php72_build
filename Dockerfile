FROM php:7.2-cli

RUN apt-get update && apt-get install -y git openssh-client curl libcurl4-openssl-dev rsync zip libzip-dev \
libmcrypt-dev libjpeg-dev libpng-dev libbz2-dev libxslt-dev libxml2-dev libgmp-dev libc-client2007e-dev libtidy-dev \
&& apt-get clean all

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

## Install Deployer with recipes
RUN composer global require deployer/deployer
RUN composer global require deployer/recipes --dev

## Add PHP extensions
RUN docker-php-ext-configure zip \
 && docker-php-ext-configure gd \
 && docker-php-ext-install bcmath bz2 calendar dba exif gd gettext gmp intl mysqli \
 opcache pcntl pdo_mysql shmop soap sockets sysvmsg sysvsem sysvshm tidy wddx xmlrpc xsl zip
 
## Configure php.ini
#ADD php.ini /usr/local/etc/php.ini

## Add Composer vendor into PATH
ENV PATH /root/.composer/vendor/bin:$PATH

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
