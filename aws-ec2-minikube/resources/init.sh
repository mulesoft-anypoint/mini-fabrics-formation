#!/bin/bash

echo "Starting the init script..."

# Update and install Docker
echo "Updating package list..."
sudo apt-get update

echo "Installing dependencies for Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Adding Docker repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "Updating package list again..."
sudo apt-get update

echo "Installing Docker..."
sudo apt-get install -y docker-ce

# Create a new user without a password
USER_DOCKER=minikubeuser
echo "Create user $USER_DOCKER..."
sudo useradd -m -s /bin/bash $USER_DOCKER
sudo passwd -d $USER_DOCKER

# Add the new user to the sudo group
sudo usermod -aG sudo $USER_DOCKER
sudo usermod -aG docker $USER_DOCKER
newgrp docker

# Install Minikube
echo "Downloading Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

echo "Making Minikube executable..."
chmod +x minikube

echo "Moving Minikube to /usr/local/bin..."
sudo mv minikube /usr/local/bin/

# Install kubectl
echo "Adding Kubernetes APT repository..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Creating Kubernetes APT sources list..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

echo "Updating package list for Kubernetes..."
sudo apt-get update

echo "Installing kubectl..."
sudo apt-get install -y kubectl

# Install kubens
echo "Installing kubectx (which includes kubens)..."
sudo snap install kubectx --classic

# Install Helm
echo "Installing Helm..."
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

# Check for necessary commands
echo "Checking for necessary commands..."
for cmd in helm kubectl kubectx docker; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found, please install it."
        exit 1
    else
        echo "$cmd is installed."
    fi
done

# PARAMETERS
echo "Setting parameters..."
CLUSTER_NAME="${cluster_name}"
CLUSTER_NODES="${cluster_nodes}"
KUBE_VERSION="${kube_version}"
RTF_VERSION="${rtf_version}"
USERNAME="${docker_username}"
PASSWORD="${docker_password}"
REGISTRY="${docker_registry}"
ACTIVATION_DATA="${activation_data}"
MULE_LICENSE_KEY="${mule_license_key}"

echo "Starting Minikube..."
su $USER_DOCKER -c "minikube start -p $CLUSTER_NAME --kubernetes-version=$KUBE_VERSION --nodes $CLUSTER_NODES"

echo "Setting context to $CLUSTER_NAME..."
su $USER_DOCKER -c "kubectx $CLUSTER_NAME"

echo "Creating namespaces..."
su $USER_DOCKER -c "kubectl create ns monitoring"
su $USER_DOCKER -c "kubectl create ns rtf"

echo "Labeling nodes..."
su $USER_DOCKER -c "kubectl label nodes $CLUSTER_NAME node-role.kubernetes.io/master=true --overwrite=true"

echo "Switching namespace to rtf..."
su $USER_DOCKER -c "kubens rtf"

echo "Creating Docker registry secret..."
su $USER_DOCKER -c "kubectl create secret docker-registry rtf-pull-secret --docker-server=$REGISTRY --docker-username=$USERNAME --docker-password=$PASSWORD"

echo "Adding Helm repository..."
su $USER_DOCKER -c "helm repo add rtf https://$REGISTRY/charts --username $USERNAME --password $PASSWORD"

echo "Generating values.yaml..."
cat << EOF > /home/$USER_DOCKER/values.yaml
activationData: $ACTIVATION_DATA
proxy:
  http_proxy:
  http_no_proxy:
  monitoring_proxy:
muleLicense: >
  $MULE_LICENSE_KEY
customLog4jEnabled: false
global:
  nodeWatcherEnabled: true
  deploymentRateLimitPerSecond: 1
  authorizedNamespaces: false
  image:
    rtfRegistry: $REGISTRY
    pullSecretName: rtf-pull-secret
  containerLogPaths:
  - /var/lib/docker/containers
  - /var/log/containers
  - /var/log/pods
EOF

chown $USER_DOCKER /home/$USER_DOCKER/values.yaml

echo "Deploying Runtime Fabric..."
su $USER_DOCKER -c "helm upgrade --install runtime-fabric rtf/rtf-agent -f /home/$USER_DOCKER/values.yaml --version $RTF_VERSION"

echo "Script completed successfully."
