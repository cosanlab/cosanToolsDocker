#CosanLab docker spec

#ANTs is a pain in the a** to install to inherit from a working container
FROM bids/base_ants:latest

MAINTAINER Eshin Jolly <eshin.jolly.gr@dartmouth.edu>

#Install utilities to download miniconda and clone our tools repo
#Then actually download and install conda and update paths
RUN apt-get update && \
	apt-get install -y wget git curl python-dev && \
	wget http://repo.continuum.io/archive/Miniconda2-latest-Linux-x86_64.sh && \
	bash Miniconda2-latest-Linux-x86_64.sh -b -p $HOME/anaconda

ENV PATH="$HOME/anaconda/bin:$PATH" \

#Install python packages
RUN conda install jupyter


#Install additional python packages
RUN pip install -q nipype nilearn nltools

#Might need these
#RUN pip install git+https://github.com/ljchang/neurolearn
#Run conda install -y pyqt

#Install required python libraries if using miniconda instead
#RUN conda install jupyter 
#RUN pip install nilearn nipype sklearn pandas matplotlib seaborn ipython
#RUN pip install git+https://github.com/ljchang/neurolearn

#Clean up to keep container weight light
RUN rm Anaconda2-4.2.0-Linux-x86_64.sh && \
	apt-get remove -y curl git && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#If we're installing google chrome (probs dont need it)
#Point to google chrome repo so apt-get can get it then install
#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
#apt-get update
#apt-get --assume-yes install google-chrome-stable
