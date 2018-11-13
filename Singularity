BootStrap: debootstrap
OSVersion: xenial
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%setup
    cp gis_dependency.makefile $SINGULARITY_ROOTFS/tmp/
    # apt-get install debootstrap

%environment
    GISBASE=/opt/osgeo/grass-7.4.2
    GRASS_PROJSHARE=/usr/share/proj
    LD_LIBRARY_PATH=/opt/osgeo/lib:/opt/osgeo/grass-7.4.2/lib
    PATH=/opt/osgeo/bin:/opt/osgeo/grass-7.4.2/bin:$PATH
    PYTHONPATH=/opt/osgeo/lib/python3.6/site-packages
    export GISBASE GRASS_PROJSHARE LD_LIBRARY_PATH PATH PYTHONPATH

%post
    echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list

    # be sure to have an updated system
    apt-get update && apt-get upgrade -y
    
    # install Ubuntu dependencies
    add-apt-repository ppa:deadsnakes/ppa
    apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        bison \
        build-essential \
        ccache \
        checkinstall \
        cmake \
        curl \
        ffmpeg \
        ffmpeg2theora \
        flex \
        g++ \
        gcc \
        gettext \
        ghostscript \
        htop \
        libavcodec-dev \
        libavformat-dev \
        libav-tools \
        libavutil-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libcairo2 \
        libcairo2-dev \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libffmpegthumbnailer-dev \
        libfftw3-3 \
        libfftw3-dev \
        libfreetype6-dev \
        libgcc1 \
        libglu1-mesa-dev \
        libgsl0-dev \
        libgtk2.0-dev \
        libgtkmm-3.0-dev \
        libjasper-dev \
        liblas-c-dev \
        libncurses5-dev \
        libnetcdf-dev \
        libperl-dev \
        libpng12-dev \
        libpnglite-dev \
        libpq-dev \
        libproj-dev \
        libreadline6 \
        libreadline6-dev \
        libsqlite3-dev \
        libswscale-dev \
        libtiff5-dev \
        libwxbase3.0-dev   \
        libwxgtk3.0-dev \
        libxmu-dev \
        libxmu-dev \
        libzmq3-dev \
        netcdf-bin \
        openjdk-8-jdk \
        pkg-config \
        proj-bin \
        proj-data \
        python3 \
	python3.6 \
        python-dateutil \
        python-dev \
        python-numpy \
        python-opengl \
        python-wxgtk3.0 \
        python-wxtools \
        python-wxversion \
	pyqt5-dev-tools \
	qtcreator \
	rsync \
        sqlite3 \
        subversion \
        swig \
        unzip \
        vim \
        wget \
        wx3.0-headers \
        wx-common \
        zlib1g-dev 

# Build CCTools

    cd /tmp && \
       wget -nv http://ccl.cse.nd.edu/software/files/cctools-7.0.8-source.tar.gz && \
       tar xzf cctools-7.0.8-source.tar.gz && \
       cd cctools-7.0.8-source && \
       ./configure --prefix=/opt/osgeo && \
       make && \
       make install

    rm -rf /tmp/build-dir /tmp/cctools*

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
    echo "/opt/osgeo/grass-7.4.2/lib" >> grass.conf
    ldconfig

# once everything is built, we can install the GRASS extensions 
    
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export PATH=/opt/osgeo/bin:/opt/osgeo/grass-7.4.2/bin:/opt/osgeo/grass-7.4.2/scripts/:$PATH && \
    export GISBASE=/opt/osgeo/grass-7.4.2 && \
    rm -rf mytmp_wgs84 && \
    grass74 -text -c epsg:3857 ${PWD}/mytmp_wgs84 -e && \
    echo "g.extension -s extension=r.sun.mp ; g.extension -s extension=r.sun.hourly ; g.extension -s extension=r.sun.daily" | grass74 -text ${PWD}/mytmp_wgs84/PERMANENT

# Install non-gis specific tools
    apt-get install -y texlive-extra-utils 
    apt-get install -y software-properties-common # to ease the adding of new ppas
    apt-get install -y libudunits2-dev # udunits2

# Install Postgres (for PostGIS)
    apt-get install -y postgresql postgresql-contrib

# Add QGIS and GRASS to sources.list
    echo "" >> /etc/apt/sources.list
    echo "## QGIS packages" >> /etc/apt/sources.list
    echo "deb     https://qgis.org/ubuntugis xenial main" >> /etc/apt/sources.list
    echo "deb-src https://qgis.org/ubuntugis xenial main" >> /etc/apt/sources.list

# Add Ubuntugis ppa, should update to latest QGIS (3.4 Madeira)
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable
    apt-get -y update
    
# Add QGIS keys
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45

# Install GRASS, then QGIS w/ Python, and latest SAGA-GIS for QGIS
    apt-get install -y saga=2.2.3+dfsg-1build1 libsaga=2.2.3+dfsg-1build1
    apt-get install -y --allow-unauthenticated qgis python-qgis qgis-plugin-grass 

%labels
Maintainer Tyson Lee Swetnam
Version v0.7
Date 2018-11-09
