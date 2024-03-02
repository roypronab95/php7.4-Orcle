# Use the official PHP 7.4 Apache image
FROM php:7.4-apache

# Update package list and install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        unzip \
        libaio1 \
        libzip-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Oracle Instant Client
ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=$ORACLE_HOME
RUN mkdir -p $ORACLE_HOME && \
    curl -o /tmp/instantclient-basic.zip https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
    curl -o /tmp/instantclient-sdk.zip https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip && \
    unzip /tmp/instantclient-basic.zip -d /opt/oracle && \
    unzip /tmp/instantclient-sdk.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_21_1/* $ORACLE_HOME && \
    echo $ORACLE_HOME > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    rm /tmp/instantclient-basic.zip /tmp/instantclient-sdk.zip

# Set environment variables for Oracle Instant Client
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient:$LD_LIBRARY_PATH
ENV OCI_HOME=/opt/oracle/instantclient
ENV OCI_LIB_DIR=/opt/oracle/instantclient
ENV OCI_INC_DIR=/opt/oracle/instantclient/sdk/include

# Enable OCI extension
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/opt/oracle/instantclient \
    && docker-php-ext-install oci8 \
    && docker-php-ext-enable oci8

# Enable required Apache modules
RUN a2enmod rewrite headers 

# Expose port 80
EXPOSE 80

# By default, start Apache
CMD ["apache2-foreground"]
