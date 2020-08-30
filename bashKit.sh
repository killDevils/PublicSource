# source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/bashKit.sh)

# if [[ $(declare -f cecho > /dev/null; echo $?) -gt 0 ]]; then source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/bashKit.sh); fi

grey='1;38;5;248';white='1;97';red='1;31';green='1;32';yellow='1;33';blue='1;34';purple='1;35';cyan='1;36';greyBlink='1;38;5;248;5';whiteBlink='1;97;5';redBlink='1;31;5';greenBlink='1;32;5';yellowBlink='1;33;5';blueBlink='1;34;5';purpleBlink='1;35;5';cyanBlink='1;36;5';whiteGrey='1;37;100';whiteRed='1;37;41';whiteGreen='1;37;42';whiteYellow='1;37;43';whiteBlue='1;37;44';whitePurple='1;37;45';whiteCyan='1;37;46';whiteGreyBlink='1;37;100;5';whiteRedBlink='1;37;41;5';whiteGreenBlink='1;37;42;5';whiteYellowBlink='1;37;43;5';whiteBlueBlink='1;37;44;5';whitePurpleBlink='1;37;45;5';whiteCyanBlink='1;37;46;5';

cecho(){
  if [[ $1 == *";"* ]]; then
    echo -e "\e[${1}m${2} \e[0m"
  else
    eval local x=\${$1}
    echo -e "\e[${x}m${2} \e[0m"
  fi
}

cstr(){
  eval local x=\${$1}
  echo -ne "\e[${x}m$2\e[0m"
}

cread(){
    read -p "$(cecho $1 "$2")" $3
}

divider(){
  if [[ -z "$1" ]]; then x=1; else x=$1; fi
  for i in {1..$x}; do
    echo
  done
}

YesNo(){
  usage $# "YesNo \"Some words about warning...\""
  [ "$?" -gt 0 ] && return 1
  cecho yellow "WARNING: $(cstr cyan "$1")"
  unset yesNo
  cstr purple 'Continue? [y/N]: '
  read yesNo
  if [[ -z "$yesNo" ]] || [[ "$yesNo" == "y" ]] || [[ "$yesNo" == "Y" ]]; then
    return 0
  elif [[ "$yesNo" == "N" ]] || [[ "$yesNo" == "n" ]]; then
    echo "See you!"
    exit 0
  else
    echo "You typed \"$yesNo\", wrong command."
    exit 1
  fi
}

addCron(){
  cread $green "Full path of the script: " scriptPath
  cread $blue "How do you change * * * * * : " fiveStar
  if [[ ! -x "$scriptPath" ]]; then
    sudo chmod a+x $scriptPath
  elif [[ ! -f "$scriptPath" ]]; then
    echo "File does not exist!"
    return 1
  fi
  crontab -l > tmpcron
  echo "$fiveStar $scriptPath" >> tmpcron
  crontab tmpcron
  rm tmpcron
  unset $fiveStar
  unset $scriptPath
}

deleteCron(){
  cread $green "Script Name: " scriptName
  awkContent=\'\!/$scriptName/\' # suppose to be '!/$scriptName/'
  eval "crontab -l | awk $awkContent > tmpcron"
  crontab tmpcron
  rm tmpcron
}

CatCurBytes(){
  echo $(cat /sys/class/net/ens4/statistics/tx_bytes)
}

Seconds2TimeInterval (){
  T=$1
  D=$((T/60/60/24))
  H=$((T/60/60%24))
  M=$((T/60%60))
  S=$((T%60))

  if [[ ${D} = 0 ]] && [[ ${H} = 0 ]]; then
    if [[ ${M} -lt 10 ]]; then
      printf '%d分钟' $M
    else
      printf '%02d分钟' $M
    fi
  elif [[ ${D} = 0 ]]; then
    if [[ ${H} -lt 10 ]]; then
      printf '%d小时%02d分钟' $H $M
    else
      printf '%02d小时%02d分钟' $H $M
    fi
  else
    printf '%d天%02d小时%02d分钟' $D $H $M
  fi
}

Days2Seconds(){
  printf %.0f $(echo "$1*24*3600" | bc -l)
}

GB2Bytes(){
  printf %.0f $(echo "$1*1024*1024*1024" | bc -l)
}

Bytes2GB(){
  printf %.$2f $(echo "$1/1024/1024/1024" | bc -l)
}

FourOperations(){
  printf %.$2f $(echo "$1" | bc -l)
}



# use inside a function.
# test if parent function misses the last parameter
# e.g. Miss_Parameter_Warning "parent funcion's e.g." $3
Miss_Parameter_Warning(){

  if [[ -z $2 ]]; then
    cstr whiteRed "[WARNING] "
    cecho yellow "Miss Argument(s)!"
    cecho cyan "e.g. "
    exit 1
  fi
}

# reopen test.sh file
# remove test.sh, nano a new test.sh
rot(){
  local f=test.sh
  rm -f $f
  touch $f; sudo chmod +x $f
  nano $f
}

If_Install_Missing_Program(){
  Miss_Parameter_Warning "If_Install_Missing_Program expect \"sudo apt update && sudo apt install expect -y\"" $1 $2
  if [[ -z $(which expect) ]]; then
    YesNo "Program \"$1\" is not found, going to install an appropriate version..."
    eval $2
  fi
}

Copy_SSH_Key_To_Client(){
  if [[ $(declare -f cecho > /dev/null; echo $?) -gt 0 ]]; then source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/bashKit.sh); fi
  Miss_Parameter_Warning "Copy_SSH_Key_To_Client root 192.168.0.1 /etc/dropbear" $3
  If_Install_Missing_Program expect "sudo apt update && sudo apt install expect -y"
  if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
    YesNo "It seems that no \"id_rsa.pub\" under \"~/.ssh/\". Going to create a new one..."
    generate_ssh=$(expect -c "
set timeout 2

spawn ssh-keygen

expect \"Enter file in which to save the key*\"
send \"\r\"

expect \"Enter passphrase*\"
send \"\r\"

expect \"Enter same passphrase again:\"
send \"\r\"

expect eof
")
echo "$generate_ssh"
  fi


  ssh $3@$1 "tee -a $2/authorized_keys" < ~/.ssh/id_rsa.pub
}


# usage $# "function example"
usage(){
	if [[ $1 -eq 0 ]]; then
    cstr whiteRed "[WARNING]"
    cecho yellow " Miss Argument(s)!"
    cecho cyan "e.g. $2"
		return 1
	fi
}
# under this func, add a line to exit parent func:
# [ "$?" -gt 0 ] && return 1

cfile(){
  usage $# "CFile(create file) <filepath>(required) <octal privilege number>(optional)"
  [ "$?" -gt 0 ] && return 1
  if [[ ! -f "$1" ]]; then
    touch $1
  fi
  if [[ -n "$2" ]]; then
    sudo chmod $2 $1
  fi
}

cdir(){
  usage $# "cdir(create directory) <directory>(required) <octal privilege number>(optional)"
  [ "$?" -gt 0 ] && return 1

  if [[ ! -d "$1" ]]; then
    mkdir -p $1
  fi
  if [[ -n "$2" ]]; then
    sudo chmod -R $2 $1
  fi
}

# Check(){
#   usage $# "Check <return or exit>(required) <comment for echo>(optional)"
#   [ "$?" -gt 0 ] && return 1
#   if [[ -n "$2" ]]; then
#     echo "$2"
#   fi
#   eval $1 1
# }
