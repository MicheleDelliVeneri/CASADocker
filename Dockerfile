# Use Rocky Linux 8 (or AlmaLinux 8) as the base image
FROM rockylinux:8

# Set environment variables
ENV CASA_VERSION=6.6.1-17 \
    CASA_PIPELINE_VERSION=2024.1.0.8 \
    CASA_URL=https://casa.nrao.edu/download/distro/casa-pipeline/release/linux/casa-6.6.1-17-pipeline-2024.1.0.8-py3.8.el8.tar.xz \
    INSTALL_DIR=/opt/casa \
    JUPYTER_PORT=8888

# Set the working directory
WORKDIR /app

# Enable necessary repositories and install required dependencies
RUN dnf install -y epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y \
    wget \
    xz \
    bzip2 \
    ca-certificates \
    glibc \
    glibc-devel \
    libXext \
    libSM \
    libXrender \
    fontconfig \
    ImageMagick \
    Xvfb \
    libnsl \
    gtk2 \
    fuse \
    perl \
    openmpi \
    openmpi-devel \
    mpich \
    python38 \
    python38-devel \
    python38-pip \
    && dnf clean all

# Download and extract CASA monolithic package
RUN mkdir -p $INSTALL_DIR && \
    wget -O /tmp/casa.tar.xz $CASA_URL && \
    tar -xJf /tmp/casa.tar.xz -C $INSTALL_DIR --strip-components=1 && \
    rm /tmp/casa.tar.xz

# Set environment variables for CASA
ENV PATH="${INSTALL_DIR}/bin:${PATH}" \
    PYTHONPATH="${INSTALL_DIR}/lib/python3.8/site-packages:${PYTHONPATH}" \
    LD_LIBRARY_PATH="${INSTALL_DIR}/lib:${LD_LIBRARY_PATH}" \
    MPI_USE=OpenMPI

RUN /opt/casa/lib/py/bin/python3 -m pip install --upgrade pip && \
    /opt/casa/lib/py/bin/python3 -m pip install jupyterlab ipykernel && \
    /opt/casa/lib/py/bin/python3 -m pip install --upgrade "urllib3<2" && \
    /opt/casa/lib/py/bin/python3 -m ipykernel install --name casa --display-name "Python (CASA)"

# Expose Jupyter Notebook port
EXPOSE $JUPYTER_PORT

# Set entrypoint to configure the environment and run CASA
ENTRYPOINT ["/bin/bash", "-c", "source /etc/profile && exec \"$@\"", "--"]
CMD ["bash"]
CMD ["/opt/casa/lib/py/bin/jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--notebook-dir=/radio-data"]