FROM igeo-gdal:latest

LABEL maintainer="Fabien ALLAMANCHE <allfab@gmail.com>"

# SET LIB VERSION
ENV JAVA_VERSION=11
ENV JETTY_VERSION=10.0.16
ENV GEOSERVER_VERSION=2.23.2

# INSTALL JAVA
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openjdk-${JAVA_VERSION}-jdk wget \
    && rm -rf /var/lib/apt/lists/*

# SET JETTY CONFIGURATION
ENV JETTY_HOME=/srv/jetty
ENV JETTY_BASE=/srv/jetty/geoserver-base

# SET EXTERNALIZATIONS
ENV GEOSERVER_HOME="/app/geoserver"
ENV GEOSERVER_DATA_DIR="${GEOSERVER_HOME}/config"
ENV GEOSERVER_GEODATA_DIR="${GEOSERVER_HOME}/geo-data"

ENV GEOSERVER_LOG_DIR="${GEOSERVER_HOME}/logs"
ENV GEOSERVER_LOG_LOCATION="${GEOSERVER_LOG_DIR}/geoserver.log"
ENV GEOWEBCACHE_CONFIG_DIR="${GEOSERVER_DATA_DIR}/gwc"
ENV GEOWEBCACHE_CACHE_DIR="${GEOSERVER_HOME}/gwc_cache_dir"
ENV INITIAL_MEMORY="2G"
ENV MAXIMUM_MEMORY="4G"
ENV JAIEXT_ENABLED="false"

# SET GEOSERVER CONFIGURATION
ENV GEOSERVER_OPTS=" \
  -DGEOSERVER_LOG_LOCATION=${GEOSERVER_LOG_LOCATION} \
  -GEOWEBCACHE_CONFIG_DIR =${GEOWEBCACHE_CONFIG_DIR} \
  -DGEOWEBCACHE_CACHE_DIR=${GEOWEBCACHE_CACHE_DIR} \
  -Dorg.geotools.coverage.jaiext.enabled=${JAIEXT_ENABLED} \
  -Dorg.geotools.shapefile.datetime=true \
  -Duser.timezone=Europe/Paris"

# SET JAVA CONFIGURATION
ENV JAVA_OPTIONS=" \
  -Xms${INITIAL_MEMORY} \
  -Xmx${MAXIMUM_MEMORY} \
  -Djava.awt.headless=true -server \
  -Dfile.encoding=UTF8 \
  -Djavax.servlet.request.encoding=UTF-8 \
  -Djavax.servlet.response.encoding=UTF-8 \
  -XX:SoftRefLRUPolicyMSPerMB=36000 \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:ParallelGCThreads=20 \
  -XX:ConcGCThreads=5 \
  -Djava.io.tmpdir=/srv/jetty/geoserver-base/tmp \
  -Djava.library.path=/usr/local/lib:/usr/local/hexagon:/usr/local/hexagon/lib/x64/release \  
  -DLD_LIBRARY_PATH=/usr/local/lib:/usr/local/hexagon:/usr/local/hexagon/lib/x64/release \
  ${GEOSERVER_OPTS}"

# CREATE & SHARE VOLUMES
RUN mkdir -p \
    "${GEOSERVER_HOME}" \
    "${GEOSERVER_DATA_DIR}" \
    "${GEOSERVER_GEODATA_DIR}" \
    "${GEOSERVER_LOG_DIR}"  \
    "${GEOWEBCACHE_CONFIG_DIR}" \
    "${GEOWEBCACHE_CACHE_DIR}"
VOLUME ${GEOSERVER_DATA_DIR}
VOLUME ${GEOSERVER_GEODATA_DIR}

# INSTALL JETTY + USER
WORKDIR ${JETTY_HOME}
RUN addgroup --quiet --system jetty \
    && adduser --quiet --system --ingroup jetty --no-create-home --disabled-password jetty \
    && usermod -c "Jetty" -d /app/jetty -g jetty jetty
RUN wget --no-check-certificate https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/${JETTY_VERSION}/jetty-home-${JETTY_VERSION}.tar.gz \
    && tar xzf jetty-home-${JETTY_VERSION}.tar.gz -C ${JETTY_HOME} --strip-components=1 \
    && rm -f ../jetty-home-${JETTY_VERSION}.tar.gz \
    && mkdir -p ${JETTY_BASE} ${JETTY_BASE}/webapps ${JETTY_BASE}/tmp \
    && cd ${JETTY_BASE} \
    && chown -R jetty:jetty ${JETTY_HOME} \
    && java -jar "$JETTY_HOME/start.jar" --add-module=server,http,deploy

# INSTALL GEOSERVER
WORKDIR ${JETTY_BASE}/webapps
RUN wget --no-check-certificate https://kumisystems.dl.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip \
    && unzip geoserver-${GEOSERVER_VERSION}-war.zip \
    && unzip geoserver.war -d geoserver \
    && rm -Rf README.html geoserver-${GEOSERVER_VERSION}-war.zip license target geoserver.war \
    && chown -R jetty:jetty ${JETTY_BASE}

# GDAL NATIVE LIB
RUN cp -f /app/data/gdal/java/gdal-${GDAL_VERSION}.jar ${JETTY_BASE}/webapps/geoserver/WEB-INF/lib \
    && ldconfig

# GDAL GEOSERVER EXT LIB
WORKDIR /app/downloads
RUN wget --no-check-certificate https://deac-fra.dl.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-gdal-plugin.zip \
    && unzip geoserver-${GEOSERVER_VERSION}-gdal-plugin.zip -d geoserver-${GEOSERVER_VERSION}-gdal-plugin \
    && cd geoserver-${GEOSERVER_VERSION}-gdal-plugin \
    && cp -f imageio-ext-* ${JETTY_BASE}/webapps/geoserver/WEB-INF/lib \
    && cp -f gs-gdal-${GEOSERVER_VERSION}.jar gt-imageio-ext-gdal-*.jar ${JETTY_BASE}/webapps/geoserver/WEB-INF/lib

# GEOSERVER Java Advanced Imaging (JAI)
# https://docs.geoserver.geo-solutions.it/edu/en/install_run/jai_io_install.html
# TO DO OR NOT

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/hexagon:/usr/local/hexagon/lib/x64/release:${JAVA_EXT_DIR}:$LD_LIBRARY_PATH

WORKDIR ${JETTY_BASE}
RUN chown -Rf jetty:jetty ${JETTY_BASE}/* \
    && rm -Rf /app/data /app/downloads
CMD ["java","-jar","/srv/jetty/start.jar"]