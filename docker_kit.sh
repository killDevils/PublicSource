# source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/docker_kit.sh)


rmc(){
  if [[ -z $1 ]]; then
    echo "Parameter missing.
    to remove all containers: rmc all
    to delete a certain one: rmc '$container_name'
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
    docker rm $1
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
    echo "缺参数。
    删除所有：“rmi all”。
    删除某一个：“rmi 镜像名”。"
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
