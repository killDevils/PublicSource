#force remove all docker containers
docker rm -vf $(docker ps -a -q)

#force remove all not running docker containers
docker rm -vf $(docker ps -a -f status=exited -f status=created -q)

# docker ps -a -f status=created
# force remove all docker images
docker rmi $(docker images -a -q)

# <Docker in Action> Chapter2 P32


DB_CID=$(docker run -d -e MYSQL_ROOT_PASSWORD=ch2demo mysql:5.7)
MAILER_CID=$(docker run -d dockerinaction/ch2_mailer)
CLIENT_ID=GGW

if [ ! -n "$CLIENT_ID" ]; then
  echo "Client ID not set"
  exit 1
fi

WP_CID=$(docker create --link $DB_CID:mysql --name wp_$CLIENT_ID -p 80 -v /tmp/ -v /run/lock/apache2/ -v /run/apache2/ -e WORDPRESS_DB_NAME=$CLIENT_ID --read-only wordpress)
docker start $WP_CID

AGENT_CID=$(docker create --name agent_$CLIENT_ID --link $WP_CID:insideweb --link $MAILER_CID:insidemailer dockerinaction/ch2_agent)
docker start $AGENT_CID


# SQL_CID=$(docker create -e MYSQL_ROOT_PASSWORD=ch2demo mysql:5.7)
# docker start $SQL_CID



#
# WP_CID=$(docker create --link $SQL_CID:mysql -p 80 -v /tmp/ -v /run/lock/apache2/ -v /run/apache2/ --read-only wordpress)
# docker start $WP_CID

# the example in the book doesn't have "-v /tmp/", and wordpress version is 4.0. But I want to use the latest version. thus causes a problem "Fatal Error Unable to create lock file: Bad file descriptor (9)". With the answer on "https://stackoverflow.com/questions/34191279/docker-fatal-error-unable-to-create-lock-file-bad-file-descriptor-9", added this.
# docker run -d --name wp --read-only -v /run/lock/apache2/ -v /run/apache2/ -v /tmp/ --link wpdb:mysql -p 80 wordpress:4

# MAILER_CID=$(docker create dockerinaction/ch2_mailer)
# docker start $MAILER_CID
#
#

# Chapter 2.5
# docker run --env MY_ENVIRONMENT_VAR="this is a test" busybox:latest env
