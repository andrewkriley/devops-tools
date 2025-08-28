#
# Dockerfile to build a comprehensive DevOps tools image.
# This image includes essential tools for cloud development and
# automation, making it ideal for CI/CD pipelines or a personal
# development environment.
#
# Maintainer: Andrew Riley andrew@andrewriley.info
#
# To build this image:
# docker build -t andreril/devops-tools:latest .
#
# To run a container from this image:
# docker run -it --rm andreril/devops-tools:latest
#

# --- Stage 1: Base Image and System Dependencies ---
# Using Ubuntu as a base image, as it offers a good balance of size
# and compatibility with a wide range of tools.
FROM ubuntu:latest

# Set environment variables to prevent interactive prompts during apt operations.
ENV DEBIAN_FRONTEND=noninteractive

# Install core system packages, including build essentials and common CLI tools.
# The 'locales' package is included to ensure correct functioning of some tools.
# The 'python3-pip' package is needed to easily install Python-based CLI tools.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    software-properties-common \
    gnupg \
    git \
    vim \
    less \
    nano \
    jq \
    locales \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Stage 2: DevOps Tooling Installation ---

# Install HashiCorp tools (Terraform and Packer) from their official repository.
# This ensures you're getting the latest stable versions directly from the source.
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends terraform packer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2 using the official bundle.
# This is the recommended method from AWS for a clean, contained installation.
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Google Cloud SDK (gcloud CLI).
# Following the official Google-recommended method for Debian-based systems.
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-cli -y

# Install kubectl.
# We download the official binary directly and place it in the PATH.
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Ansible using the APT repository
# This is a good way to get a recent version without relying on OS repositories.
# Install Ansible
RUN apt-get update && apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# --- Stage 3: Container Configuration ---

# Set the working directory for the user inside the container.
WORKDIR /app

# Define metadata for the image. This information is displayed on Docker Hub
# and helps users understand what the image contains.
# Labels are a best practice for providing structured metadata.
LABEL maintainer="Andrew Riley andrew@andrewriley.info"
LABEL org.label-schema.name="devops-tools"
LABEL org.label-schema.description="A comprehensive Docker image for cloud development and DevOps, including Terraform, Packer, AWS CLI, gcloud, kubectl, and Ansible."
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-url="https://github.com/andrewkriley/devops-tools"

# --- Licensing Information ---
# This project is intended to be open-source. For a freely available
# project, a permissive license like MIT is highly recommended.
# You should include a full LICENSE file in your repository.
#
LABEL org.label-schema.license="MIT"
# LABEL org.label-schema.vcs-ref="<commit-sha>"
#
# The `vcs-ref` label can be used to tag a specific Git commit hash.

# Set the default command to start a bash shell, which is useful for interactive use.
# CMD ["/bin/bash"]
# It's often better to use ENTRYPOINT to make the container behave like an
# executable, and CMD to provide default arguments. For a "tools" image,
# a simple CMD is sufficient, but this is a good practice to be aware of.
ENTRYPOINT ["/bin/bash"]
