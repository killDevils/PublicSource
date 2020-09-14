# source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/docker_kit.sh)


rmc(){
  if [[ -z $1 ]]; then
    echo "Parameter missing.
    to remove all containers: rmc all
    to delete a certain one: rmc <CONTAINER_NAME>
    to delete all stopped: rmc stopped"
    return 0
  fi
  running_containers=$(docker container ls -q)
  all_containers=$(docker container ls -aq)
  if [[ $1 == "all" ]]; then
    if [[ -z "$all_containers" ]]; then
      echo "No container exists."
      return 0
    fi
    if [[ -n "$running_containers" ]]; then
      echo "Shutting down all running containers..."
      docker stop $running_containers
      echo "All containers stopped."
    fi
    echo "Removing: $all_containers"
    docker rm $all_containers
  elif [[ $1 == "stopped" ]]; then
    docker rm $(docker ps -a -q) 2> /dev/null
  else
    echo "Shutting down $1..."
    docker stop $1
    echo "$1 stopped."
    echo "Removing: $1"
    docker rm $1
    echo "$1 removed."
  fi
}


lsc(){
  if [[ -z $1 ]]; then
    docker ps -a
    return 0
  fi
  case $1 in
    # all ) docker ps -a;;
    running ) docker ps --filter status=running;;
    stopped ) docker ps --filter status=exited;;
  esac
}

rmi(){
  if [[ -z "$1" ]]; then
    echo "Parameter missing.
    to delete all images: rmi all
    to delete a certain one: rmi <IMAGE_NAME>"
    return 0
  fi
  if [[ "$1" == "all" ]]; then
    docker rmi -f $(docker image ls -q) 2> /dev/null
  else
    docker rmi -f $1
  fi
}


lsi(){
  docker image ls
}

ssd(){
  if [[ -z $1 ]]; then
    echo "Parameter missing.
    ssd <CONTAINER_NAME>
    to delete a certain one: rmc <CONTAINER_NAME>
    to delete all stopped: rmc stopped"
    return 0
  fi
  docker exec -it $1 bash
}
