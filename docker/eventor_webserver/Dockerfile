# Based on manual compile instructions at http://wiki.nginx.org/HttpLuaModule#Installation
FROM ubuntu:14.04

ENV VER_NGINX_DEVEL_KIT=0.3.0
ENV VER_LUA_NGINX_MODULE=0.10.5
ENV VER_NGINX=1.9.12
ENV VER_LUAJIT=2.0.4

ENV NGINX_DEVEL_KIT ngx_devel_kit-${VER_NGINX_DEVEL_KIT}
ENV LUA_NGINX_MODULE lua-nginx-module-${VER_LUA_NGINX_MODULE}
ENV NGINX_ROOT=/nginx
ENV WEB_DIR ${NGINX_ROOT}/html

ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.0

RUN apt-get -qq update
RUN apt-get -qq -y install wget vim-nox python-setuptools geoip-bin geoip-database geoip-dbg libgeoip-dev
RUN apt-get -qq -y install unzip
RUN easy_install supervisor

#install java oracle jdk
RUN apt-get install -q -y --no-install-recommends wget software-properties-common python-software-properties
RUN apt-add-repository -y ppa:webupd8team/java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN apt-get update && apt-get install -q -y --no-install-recommends oracle-java8-installer

#install flume
RUN mkdir /opt/flume
RUN wget -qO- http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz \
  | tar zxvf - -C /opt/flume --strip 1

ADD start-flume.sh /opt/flume/bin/start-flume
ADD flume.conf /opt/flume/conf/

ENV PATH /opt/flume/bin:$PATH

# ***** BUILD DEPENDENCIES *****

# Common dependencies (Nginx and LUAJit)
RUN apt-get -qq -y install make
# Nginx dependencies
RUN apt-get -qq -y install libpcre3
RUN apt-get -qq -y install libpcre3-dev
RUN apt-get -qq -y install zlib1g-dev
RUN apt-get -qq -y install libssl-dev
# LUAJit dependencies
RUN apt-get -qq -y install gcc

# ***** DOWNLOAD AND UNTAR *****

# Download
RUN wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz
RUN wget http://luajit.org/download/LuaJIT-${VER_LUAJIT}.tar.gz
RUN wget https://github.com/simpl/ngx_devel_kit/archive/v${VER_NGINX_DEVEL_KIT}.tar.gz -O ${NGINX_DEVEL_KIT}.tar.gz
RUN wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz
# Untar
RUN tar -xzvf nginx-${VER_NGINX}.tar.gz && rm nginx-${VER_NGINX}.tar.gz
RUN tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz && rm LuaJIT-${VER_LUAJIT}.tar.gz
RUN tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz && rm ${NGINX_DEVEL_KIT}.tar.gz
RUN tar -xzvf ${LUA_NGINX_MODULE}.tar.gz && rm ${LUA_NGINX_MODULE}.tar.gz

# ***** BUILD FROM SOURCE *****

# install 51degrees module
RUN mkdir /tmp/51degrees
RUN mkdir /usr/local/share/51Degrees_module
WORKDIR /tmp/51degrees
RUN wget https://raw.githubusercontent.com/51Degrees/Java-Device-Detection/master/data/51Degrees-LiteV3.2.trie
RUN wget https://github.com/51Degrees/Device-Detection/archive/v3.2.6.4.tar.gz
RUN mv 51Degrees-LiteV3.2.trie /usr/local/share/51Degrees_module
RUN tar -xzvf v3.2.6.4.tar.gz
WORKDIR /tmp/51degrees/Device-Detection-3.2.6.4/nginx
RUN make build trie
RUN make test
RUN cp -r /tmp/51degrees/Device-Detection-3.2.6.4/nginx/51Degrees_module/* /usr/local/share/51Degrees_module

# LuaJIT
WORKDIR /LuaJIT-${VER_LUAJIT}
RUN make
RUN make install

# Nginx with LuaJIT
WORKDIR /nginx-${VER_NGINX}
RUN ./configure \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --user=www-data \
    --group=www-data \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --without-http_memcached_module \
    --with-http_geoip_module \
    --with-ipv6 \
    --with-threads \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --prefix=${NGINX_ROOT} \
    --with-ld-opt="-Wl,-rpath,${LUAJIT_LIB},-lm" --add-module=/${NGINX_DEVEL_KIT} \
    --with-cc-opt="-DFIFTYONEDEGREES_TRIE -DFIFTYONEDEGREES_NO_THREADING" \
    --add-module=/usr/local/share/51Degrees_module \
    --add-module=/${LUA_NGINX_MODULE}
RUN make -j2
RUN make install
RUN ln -s ${NGINX_ROOT}/sbin/nginx /usr/local/sbin/nginx

# ***** MISC *****
WORKDIR ${WEB_DIR}
EXPOSE 80
EXPOSE 443

# ***** CLEANUP *****
RUN rm -rf /nginx-${VER_NGINX}
RUN rm -rf /LuaJIT-${VER_LUAJIT}
RUN rm -rf /${NGINX_DEVEL_KIT}
RUN rm -rf /${LUA_NGINX_MODULE}
# TODO: Uninstall build only dependencies?
# TODO: Remove env vars used only for build?

RUN mkdir /var/log/requests
ADD nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /var/log/supervisord
RUN touch /var/log/supervisord/logrotate.log

ADD supervisord.conf /etc/
ADD sysctl.conf /etc/
ADD limits.conf /etc/security/
ADD logrotate.sh /logrotate.sh

COPY index.min.js /usr/share/nginx/html/index.min.js

#install lua modules
RUN mkdir /tmp/lua-modules
WORKDIR /tmp/lua-modules
RUN wget https://github.com/openresty/lua-resty-string/archive/v0.09.tar.gz
RUN tar -xzvf v0.09.tar.gz && rm v0.09.tar.gz && mv lua-resty-string-0.09 lua-resty-string

RUN wget https://github.com/cloudflare/lua-resty-cookie/archive/v0.1.0.tar.gz
RUN tar -xzvf v0.1.0.tar.gz && rm v0.1.0.tar.gz && mv lua-resty-cookie-0.1.0 lua-resty-cookie

RUN wget https://github.com/tcjennings/LUA-RFC-4122-UUID-Generator/archive/master.zip
RUN unzip master.zip

RUN cp -rf /tmp/lua-modules/lua-resty-cookie/lib/* /usr/local/share/lua/5.1/
RUN cp -rf /tmp/lua-modules/lua-resty-string/lib/* /usr/local/share/lua/5.1/
RUN mkdir /usr/local/share/lua/5.1/uuid
RUN cp -rf /tmp/lua-modules/LUA-RFC-4122-UUID-Generator-master/* /usr/local/share/lua/5.1/uuid

RUN mkdir /tmp/geoip
WORKDIR /tmp/geoip
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
RUN gunzip GeoIP.dat.gz && gunzip GeoLiteCity.dat.gz
RUN mkdir /usr/share/GeoIP/GeoIP/
RUN mv GeoIP.dat /usr/share/GeoIP/GeoIP/GeoIP.dat
RUN mv GeoLiteCity.dat /usr/share/GeoIP/GeoIP/GeoLiteCity.dat

CMD supervisord -c /etc/supervisord.conf && nginx