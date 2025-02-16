# CASADocker

1. Install Docker
2. ```docker build --platform linux/amd64 -t casa-python .```
3. ```docker run --platform linux/amd64 --rm -it -p 8888:8888 -v /pathonyourmachine:/radio-data casa-python```