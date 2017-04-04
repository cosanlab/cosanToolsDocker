#COSANLAB DOCKERSPEC

#BECAUSE WE CANT BASE FROM TWO IMAGES WE'RE GOING TO BASE FROM ANTS (BECAUSE IT'S A PAIN IN THE A** TO INSTALL), AND THEN DUMP THE ANACONDA DOCKERFILE CONTENTS IN HERE

#########################
### INHERIT FROM ANTS ###
#########################
FROM bids/base_ants@sha256:bf87a7c55dc13a6ef0959971e77a7bbc9c6885015287fb5ddc5f8c101dc47240

MAINTAINER Eshin Jolly <eshin.jolly.gr@dartmouth.edu>

#################################
###INHERIT FROM ANACONDA ########
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

#INSTALL NIX PROGRAMS
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion curl grep sed dpkg graphviz

#INSTALL ANACONDA AND UPDATE PATH
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

#UPDATE PATH
ENV PATH /opt/conda/bin:$PATH

#NEED TINI TO GET NOTEBOOKS WORKING PROPERLY AS IT DEALS WITH SPAWNING A CHILD PROCESS TO HANDLE COMMUNICATION WITH THE NOTEBOOK SERVER
RUN apt-get install -y python-dev && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

############################
### ADD ADDITIONAL TOOLS ###
############################

#INSTALL FSL
RUN curl -sSL http://neuro.debian.net/lists/trusty.us-nh.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get install -y fsl-core && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#CONFIG FSL
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=/usr/lib/fsl/5.0:$PATH
ENV FSLMULTIFILEQUIT=TRUE
ENV POSSUMDIR=/usr/share/fsl/5.0
ENV LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH
ENV FSLTCLSH=/usr/bin/tclsh
ENV FSLWISH=/usr/bin/wish
ENV FSLOUTPUTTYPE=NIFTI_GZ

#CONFIG PYTHONPATH
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

#INSTALL ADDITIONAL PYTHON PACKAGES
RUN pip install seaborn nibabel nilearn
RUN pip install git+https://github.com/nipy/nipype
RUN pip install git+https://github.com/ljchang/nltools
RUN pip install git+https://github.com/cosanlab/cosanlab_preproc

#ALWAYS INIT WITH TINI
ENTRYPOINT [ "/usr/bin/tini", "--" ]

#LISTEN AT THIS PORT
EXPOSE 8888

#WITHOUT ANY RUN ARGS, DEFAULT START THE CONTAINER USING A SHELL
CMD [ "/bin/bash" ]