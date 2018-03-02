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

## GRASS
$(TARGET)/bin/grass74: $(TARGET)/bin/gdalinfo
	(cd build-dir \
	 && wget $(WGET_FLAGS) https://grass.osgeo.org/grass74/source/grass-7.4.0.tar.gz \
	 && tar xzf grass-7.4.0.tar.gz \
	 && cd grass-7.4.0 \
	 && export LDFLAGS="-Wl,-rpath,$(TARGET)/lib -lpthread" \
	 && ./configure --enable-64bit --prefix=$(TARGET) --with-libs=$(TARGET)/lib \
	 	--with-proj-share=/usr/share/proj --with-gdal=$(TARGET)  --with-cxx \
		--without-fftw --without-python --with-geos=$(TARGET)/bin --with-libs=$(TARGET)/lib \
		-with-opengl=no --with-netcdf --without-tcltk --with-sqlite=yes --with-freetype=yes \
		--with-freetype-includes="/usr/include/freetype2/" --with-openmp \
	 && (make || make || make) \
	 && make install)

## GDAL_GRASS
$(TARGET)/lib/gdalplugins/gdal_GRASS.so: $(TARGET)/bin/grass74 $(TARGET)/bin/gdalinfo
	(cd build-dir \
	 && wget $(WGET_FLAGS) http://download.osgeo.org/gdal/2.2.3/gdal-grass-2.2.3.tar.gz \
	 && tar xzf gdal-grass-2.2.3.tar.gz \
	 && cd gdal-grass-2.2.3 \
	 && export LDFLAGS="-L$(TARGET)/grass-7.4.0/lib" \
	 && ./configure --with-gdal=$(TARGET)/bin/gdal-config --with-grass=$(TARGET)/grass-7.4.0 --prefix=$(TARGET) \
	 && make \
	 && make install)

## Saga-GIS
$(TARGET)/bin/saga-gis: $(TARGET)/bin/grass74 $(TARGET)/lib/gdalplugins/gdal_GRASS.so
	(cd build-dir \
	 && wget $(WGET_FLAGS) 'https://tenet.dl.sourceforge.net/project/saga-gis/SAGA%20-%206/SAGA%20-%206.3.0/saga-6.3.0.tar.gz' \
	 && tar xzf saga-6.3.0.tar.gz \
	 && cd saga-6.3.0 \
	 && ./configure --prefix=$(TARGET) --disable-odbc \
	 && make \
	 && make install)
