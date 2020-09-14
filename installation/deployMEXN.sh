# this script is suitable for deploying following packages in ubuntu 20.04 LTS container:
# curl
# nginx
# nodejs 14.x

# Since in docker official container Ubuntu 20.04, default user is root, so, the following commands do not use sudo.
apt update -y
apt install curl wget nano -y

apt install nginx -y

curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs

# wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
#
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
#
# apt-get update
#
# apt-get install -y mongodb-org
npm install -g @vue/cli

vue create PROJECTNAME

# cd to the PROJECTNAME folder
npm init
