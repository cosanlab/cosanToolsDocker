## CosanLab Docker Analysis Container  
**(work in progress)**  
Full Python based analysis environment including tools for Neuroimaging Analysis  

## Basic Use  

The following command starts a container with a Jupyter Notebook listening on port 8888:  

`docker run -d -p 8888:8888 cosantools jupyter notebook --port=8888 --no-browser --ip=0.0.0.0`  

You can navigate to localhost:8888 on your machine to access this notebook just as you would normally. Keep in mind that it actually lives and is being served from within the container!  

Stopping and restarting this container (e.g `docker start containerNum && docker attach containerNum`) will start serving the noteboook automatically if the container was created with the command above.  

Alternatively you can create a container that defaults to a shell environment and launch a notebook server, ipython, etc from within as you would on your local machine:  

`docker run -it 8888:8888 cosantools`  
`jupyter notebook --port=8888 --no-browser --ip=0.0.0.0`

## Currently contains:  
- [Anaconda package management and scientific python stack](https://github.com/conda/conda)
- [ANTs Normalization Tools](https://github.com/stnava/ANTs)
- [Neurolearn](https://github.com/ljchang/nltools)

## Todo:  
- Strip down package needs and overhead
- Miniconda with required dependencies doesn't shrink docker image that much...