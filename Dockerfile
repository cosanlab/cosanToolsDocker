FROM ubuntu:xenial-20161213

##########################
### Setup environment ####
##########################

# Install required system packages
RUN apt-get update --fix-missing && apt-get install -y eatmydata

RUN eatmydata apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 libfreetype6-dev \
    git \
    mercurial \
    subversion \
    curl grep sed \
    dpkg \
    graphviz \
    vim nano \
    libgl1-mesa-glx \
    ffmpeg \
    fonts-liberation \
    build-essential \
    gcc \
    pkg-config \
    ca-certificates \
    xvfb \
    autoconf \
    libtool

# Add Neurodebian package repositories (i.e. for FSL)
RUN curl -sSL http://neuro.debian.net/lists/trusty.us-nh.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update

#######################
### Setup Anaconda ####
#######################

# Download and install
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

# Setup path
ENV PATH /opt/conda/bin:$PATH
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

###################
### Setup ANTS ####
###################

# Download and install (NeuroDocker build)
ENV ANTSPATH=/usr/lib/ants
RUN mkdir -p $ANTSPATH && \
    curl -sSL "https://dl.dropbox.com/s/2f4sui1z6lcgyek/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.tar.gz" \
    | tar -xzC $ANTSPATH --strip-components 1

# Setup path
ENV PATH=$ANTSPATH:$PATH

#################
## Setup FSL ####
#################

# Setup neurodebian repo and install
RUN apt-get install -y fsl-core && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Config
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=/usr/lib/fsl/5.0:$PATH
ENV FSLMULTIFILEQUIT=TRUE
ENV POSSUMDIR=/usr/share/fsl/5.0
ENV LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH
ENV FSLTCLSH=/usr/bin/tclsh
ENV FSLWISH=/usr/bin/wish
ENV FSLOUTPUTTYPE=NIFTI_GZ


########################################
## Setup Additional Python packages ####
########################################

RUN pip install \
    hypertools dask mne dask pynv nipype && \
    pip install git+https://github.com/ljchang/nltools && \
    pip install git+https://github.com/cosanlab/cosanlab_preproc

##########################
## Container settings ####
##########################

ENTRYPOINT ["/bin/bash"]

EXPOSE 8888
