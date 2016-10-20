#COSANLAB DOCKERSPEC

#ANTS IS A PAIN IN THE A** TO INSTALL SO INHERIT FROM A WORKING CONTAINER
FROM bids/base_ants:latest

MAINTAINER Eshin Jolly <eshin.jolly.gr@dartmouth.edu>

#STEAL A BUNCH FROM CONTINUUM DOCKERSPEC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

#INSTALL NIX PROGRAMS
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion curl grep sed dpkg

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

#NEED TINI TO GET NOTEBOOKS WORKING PROPERLY AS IT DEALS WITH SPAWNING A CHILD PROCESS TO HANDLE COMMUNICATION WITH THE NOTEBOOK SERVER
RUN apt-get install -y python-dev && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

#UPDATE PATH
ENV PATH /opt/conda/bin:$PATH

#INSTALL ADDITIONAL PYTHON PACKAGES
RUN pip install nipype nilearn nltools

#ALWAYS INIT WITH TINI
ENTRYPOINT [ "/usr/bin/tini", "--" ]

#LISTEN AT THIS PORT
EXPOSE 8888

#WITHOUT ANY RUN ARGS, DEFAULT START THE CONTAINER USING A SHELL
CMD [ "/bin/bash" ]