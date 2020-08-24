#force remove all docker containers
docker rm -vf $(docker ps -a -q)

#force remove all not running docker containers
docker rm -vf $(docker ps -a -f status=exited -f status=created -q)

# docker ps -a -f status=created
# force remove all docker images
docker rmi $(docker images -a -q)


# totally clean docker
docker rm -vf $(docker ps -a -q) && docker rmi $(docker images -a -q)

# normally stop and rm all containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# use mattrayner/lamp
docker run -i -t -p "80:80" -v ${PWD}/Documents/GitHub/bHTMLx:/app:ro -v ${PWD}/Documents/GitHub/bHTMLx/mysql:/var/lib/mysql mattrayner/lamp:latest-1804










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
