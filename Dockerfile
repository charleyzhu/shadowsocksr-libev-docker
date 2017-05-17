FROM alpine:3.5

MAINTAINER Charley <2555085@gmail.com>

WORKDIR /root

ENV KCP_VERSION 20170329 
ENV TZ 'Asia/Shanghai'

ADD entrypoint.sh /root/entrypoint.sh
ADD kcptun.cfg /etc/kcptun.cfg


RUN set -ex \
    && apk add --no-cache libcrypto1.0 \
                          libev \
                          libsodium \
                          pcre \
                          udns \
                          tzdata \
                          bash \
    && apk add --no-cache \
               --virtual TMP autoconf \
                             automake \
                             build-base \
                             curl \
                             gettext-dev \
                             libev-dev \
                             libsodium-dev \
                             libtool \
                             linux-headers \
                             openssl-dev \
                             pcre-dev \
                             tar \
                             udns-dev \
                             git \
                             wget \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && curl -sSL https://github.com/xtaci/kcptun/releases/download/v$KCP_VERSION/kcptun-linux-amd64-$KCP_VERSION.tar.gz | tar xz \
        && mv server_linux_amd64 /usr/bin/kcptun \
        && rm -f client_linux_amd64 kcptun-linux-amd64-$KCP_VERSION.tar.gz $SS_VERSION.tar.gz \
    && git clone https://github.com/shadowsocksr/shadowsocksr-libev.git /root/ss \
        && cd /root/ss \
        && curl -sSL https://github.com/shadowsocks/ipset/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libipset \
        && curl -sSL https://github.com/shadowsocks/libcork/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libcork \
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make install \
        && cd .. \
    && rm -rf /root/ss \
    && apk del TMP \
    && chmod a+x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]