# CASADocker

This Docker installs CASA 6.6.1 and Jupyter Hub. 
It allows to use CASA inside a JupyterHub in your browser. 


1. Install Docker
2. ```docker build --platform linux/amd64 -t casa-python .```
3. ```docker run --platform linux/amd64 --rm -it -p 8888:8888 -v /pathonyourmachine:/radio-data casa-python```
