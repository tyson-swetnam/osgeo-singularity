BootStrap: debootstrap
OSVersion: bionic
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%setup
    cp gis_dependency.makefile $SINGULARITY_ROOTFS/tmp/
    # apt-get install debootstrap

%environment
    GISBASE=/opt/osgeo/grass-7.4.0
    GRASS_PROJSHARE=/usr/share/proj
    LD_LIBRARY_PATH=/opt/osgeo/lib:/opt/osgeo/grass-7.4.0/lib
    PATH=/opt/osgeo/bin:/opt/osgeo/grass-7.4.0/bin:$PATH
    PYTHONPATH=/opt/osgeo/lib/python3.6/site-packages
    export GISBASE GRASS_PROJSHARE LD_LIBRARY_PATH PATH PYTHONPATH

%post
    echo "deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list

    # be sure to have an updated system
    apt-get update && apt-get upgrade -y
    
    # install Ubuntu dependencies and Python 
    apt-get install -f -y software-properties-common \
	apt-utils \
	bison\
	build-essential \
	flex \
	g++ \
        gcc \
        gettext \
	libcairo2 \
        libcairo2-dev \
	libcanberra-gtk-module \
	libcanberra-gtk3-module \
	libwxbase3.0-dev \
        libwxgtk3.0-dev \
	python-dev \
        python3-dev \
        python3-distutils \
	texlive-extra-utils \
	wget \
	wx3.0-headers \
	zlib1g-dev 

    apt-get install -f \
	libproj-dev \
	proj-data \
	proj-bin -y
    apt-get install libgdal-dev python-gdal gdal-bin -y
    apt-get install -f -y \
	libgeos-dev \
	libgdal-doc 
# PDAL - still having an issue here
#    apt-get install -vv -f -y \
#	libpdal-dev \
#	pdal \
#	libpdal-plugin-python 
    apt-get install -f -y netcdf-bin 
    
# set locale (this fixes an error we had in GRASS environment on startup)
      locale-gen en_GB en_GB.UTF-8
      dpkg-reconfigure locales 
      echo "LC_ALL=en_GB.UTF-8" >> /etc/environment
      echo "LANG=en_GB.UTF-8" >> /etc/environment

# Makefile for GEOS, GDAL, GRASS, SAGA-GIS
    cd /tmp && make -f gis_dependency.makefile

    echo "Updating library paths"
    cd /etc/ld.so.conf.d
    echo "/opt/osgeo/lib" >> osgeo.conf
    echo "/opt/osgeo/lib64" >> osgeo.conf
    echo "/opt/osgeo/grass-7.4.0/lib" >> grass.conf
    ldconfig

# once everything is built, we can install the GRASS extensions 
    
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export PATH=/opt/osgeo/bin:/opt/osgeo/grass-7.4.0/bin:/opt/osgeo/grass-7.4.0/scripts/:$PATH && \
    export GISBASE=/opt/osgeo/grass-7.4.0 && \
    rm -rf mytmp_wgs84 && \
    grass74 -text -c epsg:3857 ${PWD}/mytmp_wgs84 -e && \
    echo "g.extension -s extension=r.sun.mp ; g.extension -s extension=r.sun.hourly ; g.extension -s extension=r.sun.daily" | grass74 -text ${PWD}/mytmp_wgs84/PERMANENT

# Install non-gis specific tools
    apt-get install -f -y texlive-extra-utils 
    apt-get install -f -y libudunits2-dev

# Install Postgres (for PostGIS)
    apt-get install -f -y postgresql postgresql-contrib

# Add QGIS and GRASS to sources.list
    echo "" >> /etc/apt/sources.list
    echo "## QGIS source packages" >> /etc/apt/sources.list
    echo "deb     https://qgis.org/ubuntu bionic main" >> /etc/apt/sources.list
    echo "deb-src https://qgis.org/ubuntu bionic main" >> /etc/apt/sources.list

# Add QGIS key
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45

# Add Ubuntugis ppa, should update to latest QGIS (3.4 Madeira)
    #add-apt-repository ppa:ubuntugis/ubuntugis
    apt-get -y update
    
# Install GRASS, then QGIS w/ Python, and latest SAGA-GIS for QGIS
    apt-get install -f -y --allow-unauthenticated qgis python-qgis qgis-plugin-grass 
	
# Build CCTools
    apt-get install -f -y locales
    cd /tmp && \
       wget -nv http://ccl.cse.nd.edu/software/files/cctools-7.0.9-source.tar.gz && \
       tar xzf cctools-7.0.9-source.tar.gz && \
       cd cctools-7.0.9-source && \
       ./configure --prefix=/opt/osgeo && \
       make && \
       make install

    rm -rf /tmp/build-dir /tmp/cctools*

%labels
Maintainer Tyson Lee Swetnam
Version v0.9
Date 2018-12-30
