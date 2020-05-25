chooseProject(){
	projectsList=$(cat $gcstkCache/projectsList)
	export PS3=$(cecho $blue "Which project:")
	select i in $projectsList
	do
		case $i in
			*) projectName=$i
		esac
		break
	done
	cecho $whiteRed "The Project you chose is \"$projectName\""
	divider
}

chooseIns(){
  if [ -z $projectName ]; then
    chooseProject
  fi
  insList=$(cat $gcstkCache/$projectName/insList | awk '!/NAME/ && /RUNNING/ { print $1 }' | sort -k1)
  export PS3=$(cecho $purple "Which instance?")
  select i in $insList
  do
    case $i in
      *) insName=$i
    esac
    break
  done
}

chooseRegion(){
  regionsList=$(cat $gcstkCache/regionsList | awk '!/NAME/ { print $1 }')
  export PS3=$(cecho $yellow "Which region?")
  select i in $regionsList
  do
  	case $i in
  		*) regionCode=$i
  	esac
  	break
  done
}

chooseZone(){
  if [ -z $regionCode ]; then
    chooseRegion
  fi
  zonesList=$(cat $gcstkCache/regionsList | grep $regionCode | awk '{ print $1 }')
  export PS3=$(cecho $cyan "Which zone?")
  select i in $zonesList
  do
  	case $i in
  		*) zoneName=$i
  	esac
  	break
  done
}

judgeHttpAndHttps(){
  httpRuleTag="http-server"
  httpRuleName="default-allow-http"
  httpsRuleTag="https-server"
  httpsRuleName="default-allow-https"

  gcloud compute firewall-rules list > firewallRulesTempList
  httpExistOrNot=$(cat firewallRulesTempList | grep tcp:80 | grep http)
  httpsExistOrNot=$(cat firewallRulesTempList | grep tcp:443 | grep https)
  if [ -z "$httpExistOrNot" ]; then
  	gcloud compute firewall-rules create $httpRuleName \
  	--action allow \
  	--direction ingress \
  	--rules tcp:80 \
  	--source-ranges 0.0.0.0/0 \
  	--priority 1000 \
  	--target-tags $httpRuleTag
  fi
  if [ -z "$httpsExistOrNot" ]; then
  	gcloud compute firewall-rules create $httpsRuleName \
  	--action allow \
  	--direction ingress \
  	--rules tcp:443 \
  	--source-ranges 0.0.0.0/0 \
  	--priority 1000 \
  	--target-tags $httpsRuleTag
  fi
}
