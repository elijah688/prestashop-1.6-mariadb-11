FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    unzip \
    apache2 \
    wget \
    apt-transport-https \
    ca-certificates

# Add PHP PPA
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update

RUN apt-get install -y \
    php7.4 \
    php7.4-cli \
    php7.4-common \
    php7.4-mysql \
    php7.4-gd \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
    libapache2-mod-php7.4

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN a2enmod rewrite

RUN rm -rf /var/www/html/* && \
    cd /var/www/html && \
    curl -LO https://download.prestashop.com/download/releases/prestashop_1.6.1.24.zip && \
    unzip prestashop_1.6.1.24.zip && \
    mv prestashop/* . && \
    rm -rf prestashop prestashop_1.6.1.24.zip

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html


EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]

