FROM debian:trixie-slim

ARG S6_OVERLAY_VERSION=3.2.0.2


RUN apt-get update && \
    apt-get install -y ghostscript xz-utils \
        unzip \
        curl \
        zip \
	less \
        bash \
	vim \
	wget \
        webp \
        libavif-bin \
        nginx \
        php8.4-fpm \
        php8.4-mysql \
        php8.4-xml \
        php8.4-igbinary \
        php8.4-imagick \
        php8.4-intl \
        php8.4-zip \
        php8.4-mbstring \
        php8.4-dev \
        php8.4-curl \
        php8.4-gd \
        php8.4-ssh2 \
        composer

RUN rm -rf /var/lib/apt/lists/*

RUN rm /etc/init.d/nginx /etc/init.d/php8.4-fpm

RUN xz --version
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -axpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -axpf /tmp/s6-overlay-x86_64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -axpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -axpf /tmp/s6-overlay-symlinks-arch.tar.xz

COPY ./config /etc
COPY ./s6-overlay/nginx /etc/s6-overlay/s6-rc.d/nginx
COPY ./s6-overlay/php-fpm84 /etc/s6-overlay/s6-rc.d/php-fpm84
COPY ./s6-overlay/user/contents.d /etc/s6-overlay/s6-rc.d/user/contents.d


WORKDIR /www

ENTRYPOINT ["/init"]

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/php-fpm-ping || exit 1



