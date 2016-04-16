# LICENSE CDDL 1.0 + GPL 2.0
#
# TRIVADS DOCKERFILES PROJECT
# ---------------------------
# This is the Dockerfile for Oracle Stream Explorer 12.2.1 (Full) Generic Distribution
#
# Credits to Bruno Borges who created the Docker weblogic Dockerfile and where this Dockerfile is based on. 
# 
# REQUIRED BASE IMAGE TO BUILD THIS IMAGE
# ---------------------------------------
# Make sure you have oraclelinux:7.0 Docker image installed.
# Visit for more info: 
#  - http://public-yum.oracle.com/docker-images/
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# Download the following files and place them into the downloads subfolder
#
# (1) fmw_12.2.1.0.0_ose_Disk1_1of1.zip
#     Download the Oracle Stream Explorere Runtime from http://www.oracle.com/technetwork/middleware/complex-event-processing/downloads/index.html
#
# (2) jdk-8u77-linux-x64.rpm
#     Download JDK from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files into the downloads sub-directory.
# To build the image, run: 
#      $ docker build -t mcairone/docker-oracle-sx:12.2.1 . 
# To start a container, run: 
#      $ docker run -d -p 9002:9002 mcairone/docker-oracle-sx:12.2.1
#

# Pull base image
# ---------------
FROM oraclelinux:7.0

# Maintainer
# ----------
MAINTAINER Mario Cairone <mario.cairone@gmail.com>

# Environment variables required for this build (do NOT change)
ENV JAVA_RPM jdk-8u77-linux-x64.rpm
ENV SX_VERSION 12.2.1.0.0
ENV SX_PKG fmw_12.2.1.0.0_oep.jar


# WLS Admin Password (you may change)
# This password is used for:
#  (a) 'oracle' Linux user in this image
# -----------------------------------
ENV ADMIN_PASSWORD welcome1

# Install unzip
# -------------
RUN yum install -y unzip

# Install and configure Oracle JDK 8u77
# -------------------------------------
COPY downloads/$JAVA_RPM /root/
RUN rpm -i /root/$JAVA_RPM && \ 
    rm /root/$JAVA_RPM
ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup required packages (unzip), filesystem, and oracle user
# ------------------------------------------------------------
RUN mkdir /home/oracle && \ 
    chmod a+xr /home/oracle && \ 
    useradd -b /home/oracle -m -s /bin/bash oracle && \ 
    echo oracle:$ADMIN_PASSWORD | chpasswd

COPY downloads/*.zip /tmp/
RUN unzip -d /home/oracle /tmp/fmw_${SX_VERSION}_ose_Disk1_1of1.zip
RUN rm /tmp/fmw_*.zip

# Add files required to build this image
COPY files/* /home/oracle/


# Adjust file permissions, go to /home/oracle as user 'oracle' to proceed with installation
RUN chown oracle:oracle -R /home/oracle
WORKDIR /home/oracle
USER oracle

# Installation of Oracle Event Processing
RUN mkdir /home/oracle/.inventory
RUN java -jar $SX_PKG -silent -responseFile /home/oracle/install.file -invPtrLoc /home/oracle/oraInst.loc -jreLoc $JAVA_HOME && \
    rm $SX_PKG /home/oracle/oraInst.loc /home/oracle/install.file

ENV ORACLE_HOME /home/oracle/product/12.2.1/oep

WORKDIR ${ORACLE_HOME}/oep/common/bin
USER oracle

RUN sh config.sh -mode=silent -silent_xml=/home/oracle/silent.xml -log=/home/oracle/create_domain.log


# Expose OEP port
EXPOSE 9002

WORKDIR /home/oracle/config/12.2.1/oep/domains/oep_domain/oep_server

ENV PATH /home/oracle/config/12.2.1/oep/domains/oep_domain/oep_server

# Define default command to start bash. 
CMD ["/home/oracle/config/12.2.1/oep/domains/oep_domain/oep_server/startwlevs.sh"]
