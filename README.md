# DevOps Tools Docker Image

NOTE: this is for the `linux/amd64` platform only.

This repository provides a comprehensive Docker image designed for cloud development and automation tasks. It bundles essential tools like Terraform, Packer, AWS CLI, Google Cloud SDK (gcloud), kubectl, and Ansible into a single, portable, and consistent environment.

The main purpose of this image is to simplify the setup of a development tools or CI/CD runner, ensuring that all team members are using the same tool versions and configurations.

# 🚀 Getting Started
Prerequisites
Docker: Ensure you have Docker installed and running on your system.

1. Building the Image
To build the Docker image from the provided Dockerfile, save the file locally and run the following command from the same directory:

```
docker build -t andreril/devops-tools:latest .
```

This command builds the image and tags it as andreril/devops-tools:latest. The process may take a few minutes as it downloads and installs all the necessary tools.

2. Running the Container
Once the image is built, you can start an interactive shell within a new container using this command:

```
docker run -it --rm andreril/devops-tools:latest
```

The `-it` flags provide an interactive terminal.

The `--rm` flag ensures the container is automatically removed when you exit the session.

You are now in a pre-configured environment with all the tools ready to use.

🛠️ Included Tools
This image contains the following key tools, as well as a range of common system utilities:

* HashiCorp Terraform: For infrastructure as code (IaC).

* HashiCorp Packer: For creating virtual machine images.

* AWS CLI v2: The command-line interface for Amazon Web Services.

* Google Cloud SDK (gcloud): The command-line tool for Google Cloud.

* kubectl: The command-line tool for managing Kubernetes clusters.

* Ansible: An open-source automation tool for configuration management.

* Core Utilities: Includes git, curl, wget, jq, vim, nano, and more for general use.

# 💡 Usage Examples
You can mount your local working directory into the container to work on your projects. This allows you to use the pre-configured tools while maintaining your files on your host machine.
```
docker run -it --rm -v $(pwd):/app andreril/devops-tools:latest
```
The `-v $(pwd):/app` flag mounts the current directory `($(pwd))` on your host machine into the container's `/app` directory, which is the default working directory set in the Dockerfile.

# 🤝 Contributing
Contributions are welcome! If you have suggestions for improvements or new tools to add, please feel free to open an issue or submit a pull request.

# 📄 License
This project is licensed under the MIT License. For more details, see the LICENSE file in this repository.