# Oracle Stream Explorer (12c)

This is a Dockerfile for Oracle Stream Explorer 12c. The purpose of this Docker container is to facilitate the setup of development and integration testing environments for developers.

Credits to Guido Schmutz who created the Docker SX Dockerfile for version 12.1.3 and where this Dockerfile is based on.

IMPORTANT: Oracle does not support Docker in any environment, including but not limited to Development, Integration, and Production environments.
How to Build

Follow this procedure:

    Download the GitHub docker-oracle-sx repository

    Go to the downloads folder

    cd docker-oracle-sx/downloads

    Download and drop the Oracle JDK 8u77 RPM 64bit file jdk-8u77-linux-x64.rpm in the downloads folder

    Download and drop the Stream Explorer 12.2.1 Runtime file fmw_12.2.1.0.0_ose_Disk1_1of1.zip in the downloads folder

    Build docker-oracle-sx using the Dockerfile

    $ docker build -t mcairone/docker-oracle-sx:12.1.3 . 

    To run an instance of Oracle Stream Explorer

    $ docker run -d -p 9002:9002 mcairone/docker-oracle-sx:12.2.1

# License

To download and run Oracle Stream Explorer regardless of inside or outside a Docker container, and regardless of Generic or Developer distribution, you must agree and accept the OTN Free Developer License Terms.

To download and run Oracle JDK regardless of inside or outside a Docker container, you must agree and accept the Oracle Binary Code License Agreement for Java SE.

All scripts and files hosted in this project and GitHub docker-oracle-sx repository required to build the Docker images are, unless otherwise noted, released under the Common Development and Distribution License (CDDL) 1.0 and GNU Public License 2.0 licenses.
