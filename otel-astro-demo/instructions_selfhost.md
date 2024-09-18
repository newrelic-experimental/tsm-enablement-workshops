# Self Host
Use these instructions to run the demo in your own evnironment rather than in a codesapce. This allows you to run for longer amongst other benefits.


## Environment Setup (Ubuntu)

The demo requires Docker, minikube, kubectl and helm.  The following is a useful user data script for ec2 Ubunutu launch template. You could also run these as root in your VM.

```
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# ----> Install docker (https://docs.docker.com/engine/install/ubuntu/)

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl unzip
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# setup permissions for docker to be run non-root
sudo usermod -aG docker ubuntu
sudo -u ubuntu bash -c  "newgrp docker"




# ----> Install minikube (https://minikube.sigs.k8s.io/docs/start/)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
sudo -u ubuntu bash -c  "minikube start"



# ----> Install kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl



# ----> Install Helm (https://helm.sh/docs/intro/install/)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Installing the demo

Once the environment is in place clone the repository and run the installer:

```
git clone https://github.com/newrelic-experimental/tsm-enablement-workshops.git
cd tsm-enablement-workshops/otel-astro-demo
./install_selfhosted.sh
```