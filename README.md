[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/567)

# Singularity container for running OSGEO software
Singularity Container for running OSGEO (GRASS, GDAL, QGIS, SAGA-GIS) on a virtual machine or localhost running Singularity (v2.4.2).

## Installing the container

First, [install Singularity](https://singularity.lbl.gov/install-linux) on your localhost or remote system. 

As of April 2018, Singularity is at version `2.4.5`

```
VERSION=2.4.5
wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz
tar xvf singularity-$VERSION.tar.gz
cd singularity-$VERSION
./configure --prefix=/usr/local
make
sudo make install
cd ..
sudo rm -rf singularity-$VERSION.tar.gz
```

## Local Build

The Singularity file has some options in the `%post` section for installing NVIDIA drivers and OpenGL - these are currently commented out in the Singularity-Hub build.

To build locally, pull this repository:

```
git clone https://github.com/tyson-swetnam/osgeo-singularity
```

Build a container locally:

```
sudo singularity build osgeo.simg osgeo-singularity/Singularity
```
