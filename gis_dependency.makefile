##!/usr/bin/make

TARGET := /opt/osgeo

SHELL := /bin/bash

export PATH := $(TARGET)/bin:$(PATH)
export CPPFLAGS := -I$(TARGET)/include
export CFLAGS := -fPIC
export CXXFLAGS := -fPIC
export LDFLAGS := -L$(TARGET)/lib
export LD_LIBRARY_PATH := $(TARGET)/lib:$(TARGET)/grass-7.4.0/lib

WGET_FLAGS := -nv --no-check-certificate

.PHONY: all setup

# list base packages as well as top level goals
all: setup $(TARGET)/lib/gdalplugins/gdal_GRASS.so $(TARGET)/bin/saga-gis

setup:
	@rm -rf build-dir
	@mkdir build-dir

##geos
$(TARGET)/lib/libgeos.so:
	(cd build-dir \
	 && wget $(WGET_FLAGS) http://download.osgeo.org/geos/geos-3.5.1.tar.bz2 \
	 && tar -xjf geos-3.5.1.tar.bz2 \
	 && cd geos-3.5.1 \
	 && ./configure --prefix=$(TARGET) --enable-python \
	 && make \
	 && make install)

## GDAL
$(TARGET)/bin/gdalinfo: $(TARGET)/lib/libgeos.so
	(cd build-dir \
	 && wget $(WGET_FLAGS) http://download.osgeo.org/gdal/2.2.2/gdal-2.2.2.tar.gz \
	 && tar xzf gdal-2.2.2.tar.gz \
	 && cd gdal-2.2.2 \
	 && ./configure --prefix=$(TARGET) --without-grass --with-netcdf --with-python \
	 	--with-hdf5 --with-geos=$(TARGET)/bin/geos-config \
	 && make \
	 && make install)
