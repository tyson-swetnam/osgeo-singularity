[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/567)

# Singularity container for running OSGEO software
Singularity Container for running OSGEO (GRASS, GDAL, QGIS, SAGA-GIS) on a virtual machine or localhost running Singularity.

## Installing the container

First, [install Singularity](https://singularity.lbl.gov/install-linux) on your localhost or remote system. 

As of early August 2018, Singularity is version `2.6.0`

```
VERSION=2.6.0
wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz
tar xvf singularity-$VERSION.tar.gz
cd singularity-$VERSION
./configure --prefix=/usr/local
make
sudo make install
cd ..
sudo rm -rf singularity-$VERSION.tar.gz
```

## Pull the Container from Singularity Hub

The `latest` image is hosted on [Singularity Hub](https://www.singularity-hub.org/collections/567).

```
singularity pull --name osgeo.simg shub://tyson-swetnam/osgeo-singularity
```

## Build locally

To build locally, pull this repository:

```
git clone https://github.com/tyson-swetnam/osgeo-singularity
cd osgeo-singularity
```

Build the container locally:

```
sudo singularity build osgeo.simg Singularity
```

**NOTE: The Singularity file has some options in the `%post` section for installing NVIDIA drivers and OpenGL - these are currently commented out in the Singularity-Hub build.**

## Starting the Container 

To run the container as a shell:

```
singularity shell osgeo.simg
```

To run the container with a GUI interface for GRASS:

```
singularity exec osgeo.simg grass74
```

For QGIS GUI:

```
singularity exec osgeo.simg qgis
```

For Saga-GIS GUI:

```
singularity exec osgeo.simg saga_gui
```

<aside class="notice">
  
If you are accessing the container remotely, make sure to use the `ssh -X` flag

</aside>
