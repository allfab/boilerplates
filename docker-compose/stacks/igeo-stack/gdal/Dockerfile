ARG BASE_IMAGE=ubuntu:22.04
ARG TARGET_BASE_IMAGE=ubuntu:22.04

FROM $BASE_IMAGE AS builder

LABEL maintainer="Fabien ALLAMANCHE <allfab@gmail.com>"

ENV JAVA_VERSION=11
ENV PROJ_VERSION=9.2.1
ENV GEOS_VERSION=3.12.0
ENV GDAL_VERSION=3.7.2
ENV JETTY_VERSION=11.0.16

# SETUP BUILD ENV FOR PROJ
USER root
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
            build-essential ca-certificates \
            g++ git make cmake wget unzip libtool automake \
            zlib1g-dev libsqlite3-dev pkg-config sqlite3 libcurl4-gnutls-dev \
            libtiff5-dev \
            vim expect \
    && rm -rf /var/lib/apt/lists/*

# Setup build env for GDAL
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
       libopenjp2-7-dev libcairo2-dev \
       python3-dev python3-numpy python3-setuptools \
       libpng-dev libjpeg-dev libgif-dev liblzma-dev libgeotiff-dev \
       curl libxml2-dev libexpat-dev libxerces-c-dev \
       libnetcdf-dev libpoppler-dev libpoppler-private-dev \
       libspatialite-dev librasterlite2-dev swig ant libhdf4-alt-dev libhdf5-serial-dev \
       libfreexl-dev unixodbc-dev  mdbtools-dev libwebp-dev \
       liblcms2-2 libpcre3-dev libcrypto++-dev libfyba-dev \
       libkml-dev libmysqlclient-dev libogdi-dev \
       libcfitsio-dev openjdk-"$JAVA_VERSION"-jdk libzstd-dev \
       libpq-dev libssl-dev libboost-dev \
       autoconf automake bash-completion libarmadillo-dev \
       libopenexr-dev libheif-dev \
       libdeflate-dev libblosc-dev liblz4-dev libbz2-dev \
       libbrotli-dev \
       libarchive-dev \
       libaec-dev \
       libqhull-dev liblerc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/downloads

## PROJ
RUN wget --no-check-certificate https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz \
    && tar xzf proj-${PROJ_VERSION}.tar.gz \
    && cd proj-${PROJ_VERSION} \
    && cmake . \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/proj-${PROJ_VERSION} \
        -DBUILD_TESTING=OFF \
    && make -j$(nproc) \
    && make install DESTDIR="/app/build"
ENV PATH=/app/build/proj-${PROJ_VERSION}/bin:$PATH

# BUILD GEOS
RUN wget --no-check-certificate https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
    && tar xjf geos-${GEOS_VERSION}.tar.bz2 \
    && cd geos-${GEOS_VERSION} \
    && cmake . \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/geos-${GEOS_VERSION} \
        -DBUILD_TESTING=OFF \
    && make -j$(nproc) \
    && make install DESTDIR="/app/build"
ENV PATH=/app/build/geos-${GEOS_VERSION}/bin:$PATH

## ECW
WORKDIR /app/downloads/hexagon
#COPY ECW LIBRARY
COPY ./resources/hexagon/* /app/downloads/hexagon
RUN unzip ECWJP2SDKSetup_5.5.0.2268.bin.zip \
    && chmod +x ECWJP2SDKSetup_5.5.0.2268.bin \
    && expect ./install-ecw-sdk.exp \
    && mkdir -p /usr/local/hexagon \
    && mv ~/hexagon/ERDAS-ECW_JPEG_2000_SDK-5.5.0/Desktop_Read-Only/* /usr/local/hexagon \
    && rm -Rf /usr/local/hexagon/lib/x64 \
    && mv /usr/local/hexagon/lib/cpp11abi/x64 /usr/local/hexagon/lib \
    && rm -Rf /usr/local/hexagon/lib/cpp11abi \
    && rm -Rf /usr/local/hexagon/lib/x64/debug \
    && rm -rf ~/hexagon \
    && rm -rf /app/downloads/hexagon

WORKDIR /app/downloads
## GDAL
RUN wget --no-check-certificate https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar xzf gdal-${GDAL_VERSION}.tar.gz \
    && cd gdal-${GDAL_VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/gdal-${GDAL_VERSION}\
        -DGDAL_USE_TIFF_INTERNAL=ON \
        -DGDAL_USE_GEOTIFF_INTERNAL=ON \
        -DGDAL_USE_SPATIALITE=ON \
        -DGDAL_USE_FREEXL=ON \
        -DGDAL_USE_ECW=ON \
        -DECW_ROOT=/usr/local/hexagon \
        -DECW_INCLUDE_DIR=/usr/local/hexagon/include \
        -DECW_LIBRARY=/usr/local/hexagon/lib/x64/release/libNCSEcw.so \
        -DBUILD_JAVA_BINDINGS=ON \
        -DBUILD_TESTING=OFF \
    && make -j$(nproc) \
    && make install DESTDIR="/app/build"

ENV PATH=/app/build/gdal-${GDAL_VERSION}/bin:$PATH
ENV GDAL_DATA=/app/build/gdal-3.7.2/share/gdal:$GDAL_DATA
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/hexagon:/usr/local/hexagon/lib/x64/release:/app/build/proj-${PROJ_VERSION}/lib:/app/build/geos-${GEOS_VERSION}/lib:/app/build/gdal-${GDAL_VERSION}/lib:/$LD_LIBRARY_PATH
RUN ldconfig


# BUILD FINAL IMAGE
FROM $TARGET_BASE_IMAGE AS runner

ENV JAVA_VERSION=11
ENV PROJ_VERSION=9.2.1
ENV GEOS_VERSION=3.12.0
ENV GDAL_VERSION=3.7.2

# PROJ dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libsqlite3-0 libtiff5 libcurl4 libcurl4-gnutls-dev \
        curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/proj-${PROJ_VERSION}/include/ /usr/local/include/
COPY --from=builder /app/build/proj-${PROJ_VERSION}/bin/ /usr/local/bin/
COPY --from=builder /app/build/proj-${PROJ_VERSION}/lib/ /usr/local/lib/

COPY --from=builder /app/build/geos-${GEOS_VERSION}/include/ /usr/local/include/
COPY --from=builder /app/build/geos-${GEOS_VERSION}/bin/ /usr/local/bin/
COPY --from=builder /app/build/geos-${GEOS_VERSION}/lib/ /usr/local/lib/

# GDAL dependencies
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3-numpy libpython3.10 \
        libjpeg-turbo8 liblerc3 qhull-bin libexpat1 libxerces-c3.2 \
        libarchive13 unixodbc libcrypto++8 libblosc1 libarmadillo10 libheif1 libpoppler118 libgif7 \
        libnetcdf19 libcfitsio-bin libopenexr25 libkmlbase1 libkmldom1 libkmlengine1 libfyba0 librasterlite2-1 \
        libmysqlclient21 libogdi4.1 libdeflate0 libcfitsio9 libhdf4-0-alt \
        libwebp7 libpng16-16 \
        libzstd1 bash libpq5 libssl3 libopenjp2-7 libspatialite7 \
        # pil for antialias option of gdal2tiles
        python3-pil \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/gdal-${GDAL_VERSION}/include /usr/local/include
COPY --from=builder /app/build/gdal-${GDAL_VERSION}/bin /usr/local/bin
COPY --from=builder /app/build/gdal-${GDAL_VERSION}/lib /usr/local/lib
COPY --from=builder /app/build/gdal-${GDAL_VERSION}/share/gdal /usr/local/share/gdal
COPY --from=builder /usr/local/hexagon /usr/local/hexagon

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/hexagon:/usr/local/hexagon/lib/x64/release:$LD_LIBRARY_PATH
ENV GDAL_DATA=/usr/local/share/gdal:$GDAL_DATA
RUN ldconfig

WORKDIR /app/data/gdal/java
COPY --from=builder /app/downloads/gdal-${GDAL_VERSION}/build/swig/java/gdal.jar /app/data/gdal/java/gdal-${GDAL_VERSION}.jar
COPY --from=builder /app/downloads/gdal-${GDAL_VERSION}/build/swig/java/libgdalalljni.so /usr/local/lib

