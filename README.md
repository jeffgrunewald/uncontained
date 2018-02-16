## Uncontained ##

Exploring the linux container ecosystem with Docker, LXC/LXD, rkt, and Kubernetes

### Setup ###

In order to speed up getting your hands on the tools, I recommend installing the clients as well as pulling and bootstrapping the Vagrant VMs prior to the session, as the size of the box files, the various packages to be provisioned, and the speed of/load on the wi-fi can all cause the setup to take several minutes each.

1. Run the setup script `setup.sh` to install the macOS packages and clients or install each one yourself

2. cd into each top-level directory within the repo (lxd, rkt, kubernetes) run the command `vagrant up` and wait for the VM to come online, then suspend the VM with `vagrant suspend` to save on system resources until the session. Lather, rinse, repeat.

### Why Vagrant? ###

With the exception of the Docker suite of tools (and Kubernetes if you're running the bleeding edge beta channel of Docker for Mac) none of the tools in this workshop run outside of a Linux distribution. If you have an easier way of managing Linux VM infrastructure for a laptop via source control than Vagrant, I'd love to hear about it.