## CosanLab Docker Analysis Container  

Full Python based analysis environment including tools for Neuroimaging Analysis used in the [CosanLab](cosanlab.com)   
*Eshin Jolly (eshin.jolly.gr@dartmouth.edu)*

#### Currently contains (and subject to change):  
- [Anaconda scientific python 2 stack @4.4.0](https://github.com/conda/conda) (including jupyter notebooks!)
- [FSL @5.1.0](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/)
- [ANTs @2.2.0](https://github.com/stnava/ANTs)
- [Neurolearn @0.3.0](https://github.com/ljchang/nltools)
- [Nipype @0.13.1](http://nipype.readthedocs.io/en/latest/)
- [Dask @0.15.2](http://dask.pydata.org/en/latest/)
- [MNE @0.14.1](https://martinos.org/mne/stable/index.html)
- [Pynv @0.1.1](https://pypi.python.org/pypi/pynv)
- [Hypertools @0.3.2](https://github.com/ContextLab/hypertools)
- [CosanLab Preproc tools](https://github.com/cosanlab/cosanlab_preproc)



## Downloading the container  

Make sure you have [docker](https://www.docker.com/) installed on your computer. Then you can use the following command:  

`docker pull ejolly/cosantoolsdocker`  

This will pull a copy of the docker image to your local machine.  
*Warning*:  This download might take a bit because the image size is quite large (~4.3Gb) because of the tools it contains.  

## Basic Use  

There are (at least) two ways you might use this container:  
#### 1. Use it to serve a jupyter notebook instance for data analysis only

The following command starts a container with a [Jupyter Notebook](http://jupyter.org/) server listening on port 8888:  

`docker run -d -p 8888:8888 ejolly/cosantoolsdocker jupyter notebook --port=8888 --no-browser --ip=0.0.0.0`  

This will create a new container running a jupyter notebook server which will look just like launching a jupyter notebook server on your local machine.  

You can navigate to localhost:8888 on your machine's internet browser to access this notebook just as you would normally. Keep in mind that it actually lives and is being served from within the container!  

To close the notebook and the container at any time simply issue a quit command in the terminal window where the jupyter notebook is being serve (ctrl/cmd + D).  

#### 2. Create an interactive container with a full ubuntu environment

The following command will create a new container and open up a bash terminal inside the container:  

`docker run -it -p 8888:8888 --name yourContainerName -v /path/to/folder/on/your/comp/to/share:/path/to/mount/folder/in/container ejolly/cosantoolsdocker`

***Port Issues***:  
*If you already have a jupyter notebook running locally on your computer at port 8888 you will probably need to close it before creating a container, then reopen it after. This is because this container only exposes port 8888, whereas jupyter notebooks will find a free port serve from if 8888 is in use.*  

*If you still have port problems, trying restarting Docker itself (click on the whale icon by your system clock and select restart).*  

This container is **persistent** so when you close it (i.e. ctr/cmd+D) it will shutdown but will not be deleted.  
You can add the `--rm` flag to the command above to auto delete on exit.

To reconnect to the **same** container you just created use the following commands:  

`docker start yourContainerName`  
`docker attach yourContainerName`  

If instead you want to create a separate **new** container, just use the `docker run` command above and supply a new container name.  

##### Serving a juptyer notebook from within this interactive container  

Within the bash shell simply use the following command to start serving a jupyter notebook:  

`jupyter notebook --port=8888 --no-browser --ip=0.0.0.0`

Because this shell is now in use serving the notebook, you might be interesting in opening up another shell within the **same** container. You can use the following command to do so:  

`docker exec -it yourContainerName /bin/bash`  

## Other helpful commands  
- See what docker images you have downloaded and can be used to create new containers:  
	+ `docker images`  
- See running container dockers:  
	+ `docker ps`  
- See all docker container you have created (including those not running):  
	+ `docker ps -a`
- Startup and connect to previously created container:
	+ `docker start yourContainerName`
	+ `docker attach yourContainerName`
- Delete a docker container:  
	+ `docker rm yourContainerName`  
- Delete a docker image:  
	+ `docker rmi yourImageName`  
- Stop a running container:  
	+ `docker stop yourContainerName`
- Execute a new command in an existing docker container
	+ `docker exec yourContainer command`
- Delete all containers that are no longer running:
	+ `docker rm $(docker ps -aq -f status=exited)`
- Force delete ALL containers
	+ `docker rm -f $(docker ps -aq)`
