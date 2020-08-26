# bash <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/installation/install_docker_and_compose.sh)

OS_Debian=$(cat /etc/os-release | head -1 | grep Debian)
OS_Ubuntu=$(cat /etc/os-release | head -1 | grep Ubuntu)

sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y


if [ -n "$OS_Debian" ]; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
elif [ -n "$OS_Ubuntu" ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
elif [ -n "$OS_Debian" ] && [ -n "$OS_Ubuntu" ]; then
  echo "This script supports only Debian or Ubuntu. For other OSs, go to https://docs.docker.com/engine/install/ for help"
fi


sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y


docker_group=$(cat /etc/group | grep docker)
user_in_docker_group=$(id -nG "$USER" | grep docker)
if [ -z "$docker_group" ] && [ -z "$user_in_docker_group" ]; then
  sudo groupadd docker
  sudo usermod -aG docker $USER
elif [ -z "$user_in_docker_group" ]; then
  sudo usermod -aG docker $USER
fi


sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose



















#
