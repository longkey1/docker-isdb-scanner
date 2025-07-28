FROM debian:bookworm

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Update apt packages
RUN apt-get -y update

# Install gosu
RUN apt-get -y install gosu

# Make working directory
ENV WORK_DIR=/work
RUN mkdir ${WORK_DIR}

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# TARGETPLATFORM
ARG TARGETPLATFORM

# Install wget
RUN apt-get update && apt-get install -y wget

# Install recisdb
ARG RECISDB_RS_VERSION
RUN PLATFORM=$( \
      case ${TARGETPLATFORM} in \
        linux/amd64 ) echo "amd64";; \
        linux/arm64 ) echo "arm64";; \
      esac \
    ) && \
    wget https://github.com/kazuki0824/recisdb-rs/releases/download/${RECISDB_RS_VERSION}/recisdb_${RECISDB_RS_VERSION}-1_${PLATFORM}.deb -O ./recisdb.deb
RUN apt install ./recisdb.deb
RUN rm ./recisdb.deb
RUN recisdb --version

# Install isdb-scanner
ARG ISDB_SCANNER_VERSION
RUN PKG_FILENAME=$( \
      case ${TARGETPLATFORM} in \
        linux/amd64 ) echo "isdb-scanner";; \
        linux/arm64 ) echo "isdb-scanner-arm";; \
      esac \
    ) && \
RUN wget https://github.com/tsukumijima/ISDBScanner/releases/download/v${ISDB_SCANNER_VERSION}/${PKG_FILENAME} -O /usr/local/bin/isdb-scanner
RUN chmod +x /usr/local/bin/isdb-scanner
RUN isdb-scanner --version
