FROM openjdk:8-jdk

MAINTAINER Tristan Everitt

ENV COLLECTD_VERSION 5.7.0

RUN buildDeps=" \
	curl \
        ca-certificates \
        bzip2 \
        build-essential \
        bison \
        flex \
        autotools-dev \
        libltdl-dev \
        pkg-config \
        librrd-dev \
        linux-libc-dev \
	librabbitmq-dev \
	#libcurl-dev \
	libxml2-dev \
	libyajl-dev \
	libdbi-dev \
	libi2c-dev \
	libmodbus-dev \
	libpcap-dev \
	libganglia1-dev \
	libopenipmi-dev \
	iptables-dev \
	#java-1.8.0-openjdk-dev \
	liblvm2-dev \
	libmemcached-dev \
	libmysqlclient-dev \
	libmosquitto-dev \
	libmnl-dev \
	libnotify-dev \
	libesmtp-dev \
	#nut-dev \
	libldap2-dev \
	libperl-dev \
	#perl-ExtUtils-Embed \
	liboping-dev \
	#postgresql-dev \
	python-dev \
	libhiredis-dev \
	librrd-dev \
	libatasmart-dev \
	libudev-dev \
	libsnmp-dev \
	libstatgrab-dev \
	libvarnishapi-dev \
	libvirt-dev \
	libmicrohttpd-dev \
	#libmongo-client-dev \
	#libriemann-client0 \
	#libriemann-client-dev \
	#protobuf-c-compiler \
	#libprotobuf-c-dev \
	#libprotobuf-dev \
	#libprotobuf-c0-dev \
	librdkafka-dev \
	libcurl4-gnutls-dev \
	libsigrok-dev \
	libpq-dev \
	libupsclient-dev \
	liblua5.2-dev \
	libmodbus-dev \
    " \
    && set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fSL "https://collectd.org/files/collectd-${COLLECTD_VERSION}.tar.bz2" -o "collectd-${COLLECTD_VERSION}.tar.bz2" \
 #   && echo "${COLLECTD_SHA256} *collectd-${COLLECTD_VERSION}.tar.bz2" | sha256sum -c - \
    && tar -xf "collectd-${COLLECTD_VERSION}.tar.bz2" \
    && rm "collectd-${COLLECTD_VERSION}.tar.bz2" \
    && ( \
        cd "collectd-${COLLECTD_VERSION}" \
        && ./configure \
            --prefix=/usr/local \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-dependency-tracking \
            --disable-static \
	--enable-amqp \
	--enable-apache \
	--enable-bind \
	--enable-ceph \
	--enable-curl \
	--enable-curl_json \
	--enable-curl_xml \
	--enable-dbi \
	--enable-dns \
	--enable-gmond \
	--enable-ipmi \
	--enable-iptables \
	--enable-java \
	--enable-log_logstash \
	--enable-lvm \
	--enable-memcachec \
	--enable-mysql \
	--enable-mqtt \
	#--enable-mongo \
	--enable-kafka \
	--enable-netlink \
	--enable-graphite \
	--enable-nginx \
	--enable-notify_desktop \
	--enable-notify_email \
	--enable-nut \
	--enable-openldap \
	--enable-perl \
	--enable-ping \
	--enable-postgresql \
	--enable-python \
	--enable-redis \
	#--enable-riemann \
	--enable-rrdtool \
	--enable-smart \
	--enable-snmp \
	--enable-varnish \
	--enable-virt \
	--enable-write_http \
	--enable-write_redis \
        && make -j"$(nproc)" \
        && make install \
    ) \
   # && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps \
    && rm -fr "collectd-${COLLECTD_VERSION}"

ADD startup.sh /startup.sh
RUN chmod a+x /startup.sh

CMD [ "/startup.sh" ]
