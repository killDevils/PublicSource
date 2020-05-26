# source <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/gcloudKit.sh)


listProjects(){
	local themeColor="yellow"
	cecho $themeColor "Here are the projects:"
	cat $gcstkCache/projectsList
	divider
}

chooseProject(){
	local themeColor="yellow"
	projectsList=$(cat $gcstkCache/projectsList)
	export PS3=$(cecho $themeColor "Which project:")
	select i in $projectsList
	do
		case $i in
			*) projectName=$i
		esac
		break
	done
	cecho $themeColor "The Project you chose is \"$projectName\""
	divider
}

listInstances(){
	local themeColor="yellow"
	if [ -z $projectName ]; then
    chooseProject
  fi
	cecho $themeColor "Here are the instances:"
	cat $gcstkCache/$projectName/insList | awk '!/NAME/ && /RUNNING/ { print $1 }' | sort -k1
	divider
}

chooseInstance(){
	local themeColor="yellow"
  if [ -z $projectName ]; then
    chooseProject
  fi
  instanceList=$(cat $gcstkCache/$projectName/insList | awk '!/NAME/ && /RUNNING/ { print $1 }' | sort -k1)
  export PS3=$(cecho $themeColor "Which instance:")
  select i in $instanceList
  do
    case $i in
      *) instanceName=$i
    esac
    break
  done
	cecho $themeColor "The Project you chose is \"$instanceName\""
	divider
}

listRegions(){
	local themeColor="yellow"
	cecho $themeColor "Here are the regions:"
	cat $gcstkCache/regionsList | awk '!/NAME/ { print $1 }'
	divider
}

chooseRegion(){
	local themeColor="yellow"
  regionsList=$(cat $gcstkCache/regionsList | awk '!/NAME/ { print $1 }')
  export PS3=$(cecho $themeColor "Which region:")
  select i in $regionsList
  do
  	case $i in
  		*) regionName=$i
  	esac
  	break
  done
	cecho $themeColor "The Region you chose is \"$regionName\""
	divider
}

listZones(){
	local themeColor="yellow"
	if [ -z $regionCode ]; then
    chooseRegion
  fi
	cecho $themeColor "Here are the zones:"
	cat $gcstkCache/regionsList | grep $regionCode | awk '{ print $1 }'
	divider
}

chooseZone(){
	local themeColor="yellow"
  if [ -z $regionCode ]; then
    chooseRegion
  fi
  zonesList=$(cat $gcstkCache/regionsList | grep $regionCode | awk '{ print $1 }')
  export PS3=$(cecho $themeColor "Which zone:")
  select i in $zonesList
  do
  	case $i in
  		*) zoneName=$i
  	esac
  	break
  done
	cecho $themeColor "The Zone you chose is \"$zoneName\""
	divider
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
