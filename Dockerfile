# Version: 0.0.1
FROM ubuntu:latest

MAINTAINER Juan Pedro Perez "jp.alcantara@geographica.gs"

# This is a clever instruction, for, if changed, will force the build command to
# skip cache and recreate the whole image from scratch
ENV REFRESHED_AT 2014-12-03_11:43
ENV POSTGRES_PASSWD postgres

# Build PostgreSQL 9.1.2
RUN apt-get update
RUN apt-get install -y build-essential gcc-4.7 python python-dev libreadline6-dev zlib1g-dev libssl-dev libxml2-dev libxslt-dev

RUN ["mkdir", "-p", "/usr/local/src/"]
ADD packages/postgresql-9.1.2.tar.bz2 /usr/local/src/
WORKDIR /usr/local/src/postgresql-9.1.2/
RUN ./configure --prefix=/usr/local --with-pgport=5432 --with-python --with-openssl --with-libxml --with-libxslt --with-zlib CC='gcc-4.7 -m64'
RUN ["make"]
RUN ["make", "install"]
WORKDIR /usr/local/src/postgresql-9.1.2/contrib
RUN ["make", "all"]
RUN ["make", "install"]
RUN groupadd postgres
RUN useradd -r postgres -g postgres
RUN echo "postgres:${POSTGRES_PASSWD}" | chpasswd -e

# Building GEOS 3.4.2
ADD packages/geos-3.4.2.tar.bz2 /usr/local/src/
WORKDIR /usr/local/src/geos-3.4.2/
RUN ["./configure"]
RUN ["make"]
RUN ["make", "install"]

# Build Proj4 4.8.0
ADD packages/proj-4.8.0.tar.gz /usr/local/src/
ADD packages/proj4-patch/src/pj_datums.c /usr/local/src/proj-4.8.0/src/
ADD packages/proj4-datumgrid-1.5.tar.bz2 /usr/local/src/
RUN ["/bin/sh", "-c", "mv /usr/local/src/proj4-datumgrid-1.5/* /usr/local/src/proj-4.8.0/nad/"]
ADD packages/proj4-patch/nad/epsg /usr/local/src/proj-4.8.0/nad/
ADD packages/proj4-patch/nad/PENR2009.gsb /usr/local/src/proj-4.8.0/nad/
WORKDIR /usr/local/src/proj-4.8.0/
RUN ["/bin/sh", "-c", "chown -R 142957:5000 /usr/local/src/proj-4.8.0/"]
RUN ./configure CC='gcc-4.7 -m64'
RUN ["make"]
RUN ["make", "install"]
RUN ["ldconfig"]

# Build PostGIS 1.5.8
ADD packages/postgis-1.5.8.tar.gz /usr/local/src/
ADD packages/postgis-1.5.8-patch/spatial_ref_sys.sql /usr/local/src/postgis-1.5.8/
WORKDIR /usr/local/src/postgis-1.5.8
RUN ./configure CC='gcc-4.7 -m64'
RUN make
RUN make install

# Postinstallation clean
WORKDIR /
RUN ["rm", "-Rf", "/usr/local/src"]

# Configuration of database
RUN ["locale-gen en_US.UTF-8"]
RUN ["locale-gen es_ES.UTF-8"]

EXPOSE 5432
CMD su postgres -c 'postgres -D /data'
