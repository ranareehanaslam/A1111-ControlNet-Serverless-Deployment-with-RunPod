#Use an official NVIDIA CUDA base image
FROM nvidia/cuda:12.4.0-base-ubuntu22.04 AS base

# Set environment variables
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    TZ=Asia/Karachi \
    PYTHONUNBUFFERED=True

# Install system dependencies including Python and pip
RUN echo 'keyboard-configuration keyboard-configuration/layout select English (US)' | debconf-set-selections && \
    echo 'keyboard-configuration keyboard-configuration/layoutcode select en' | debconf-set-selections && \
    apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    wget \
    bzip2 \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    libgoogle-perftools4 \
    libtcmalloc-minimal4 \
    socat \
    ffmpeg \
    net-tools \
    lsb-release \
    gnupg \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Create a symbolic link for python to point to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Additional system packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y bc && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory to root
WORKDIR /

# Install Python dependencies
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools

# Install the specified Python package
RUN python3 -m pip install --no-cache-dir runpod==1.7.0

# Copy the directories and files into the root directory /
COPY builder/ /builder/
COPY src/ /src/
COPY stable-diffusion-webui/ /stable-diffusion-webui/
COPY Dockerfile /Dockerfile
COPY webui.sh /webui.sh
COPY run_webui_with_exit.sh /run_webui_with_exit.sh


# Copy additional files to the container
COPY realvisxlV40_v40LightningBakedvae.safetensors /stable-diffusion-webui/models/Stable-diffusion/
COPY controlnet-depth-sdxl.safetensors /stable-diffusion-webui/extensions/sd-webui-controlnet/models/
COPY builder/cache.py /stable-diffusion-webui/cache.py

# Copy src folder content to root directory
ADD src /

# Run the script
RUN ["/bin/bash", "/run_webui_with_exit.sh"]


RUN cd /stable-diffusion-webui && python cache.py --use-cpu=all --ckpt /stable-diffusion-webui/models/Stable-diffusion/realvisxlV40_v40LightningBakedvae.safetensors

# Cleanup section (Worker Template)
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*



# Set permissions and specify the command to run
RUN chmod +x /start.sh
CMD /start.sh
