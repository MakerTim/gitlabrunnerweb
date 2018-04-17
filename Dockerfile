# Commands om de server te installeren #
Hieronder heb ik mbv sub hoofdstukken alle commands neergezet die ik ook heb uitgevoerd
Wij zitten op een debian server (Versie Stretch)
``` 
NOTE: Dit project werkt met DNS records die specifiek naar 1 ip gaan 
Pas deze aan, anders grote kans dat delen NIET werken
makertim.nl is als hoofd DNS altijd gebruikt, voor opzoek refrences
```

## SUDO ##
apt-get install sudo


## DOCKER ##
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

## Nginx router ##
``` for routing with dns```

docker run -d \
	-p 80:80 \
	-v /var/run/docker.sock:/tmp/docker.sock:ro \
	jwilder/nginx-proxy


## Gitlab ##
docker run -d \
	--hostname git.ipose.makertim.nl \
	-e VIRTUAL_HOST=git.ipose.makertim.nl \
	-p 8080:80 \
	--name gitlab \
	--restart always \
	--volume /srv/gitlab/config:/etc/gitlab \
	--volume /srv/gitlab/logs:/var/log/gitlab \
	--volume /srv/gitlab/data:/var/opt/gitlab \
	gitlab/gitlab-ce:latest


## Gitlab Runner ##
docker run -d \
	--name gitlab-runner \
	--restart always \
	-v /srv/gitlab-runner/config:/etc/gitlab-runner \
	-v /srv/production:/srv/production \
	-v /var/run/docker.sock:/var/run/docker.sock \
	makertim/gitlab-runner-node-gradle


## SonarQube ##
docker run -d \
	-e VIRTUAL_HOST=sonarqube.ipose.makertim.nl \
	-p 9000:9000 \
	--name SonarQube \
	--restart always \
	sonarqube:alpine


## Sonatype Nexus3 ##
docker run -d \
	-e VIRTUAL_HOST=nexus.ipose.makertim.nl \
	-p 8081:8081 \
	--name nexus \
	sonatype/nexus3

# CD
## Create directories for production ##
mkdir -p -m 777 /srv/production/front
mkdir -p -m 777 /srv/production/back
mkdir -p -m 777 /srv/production/compiler

## Frontend ##
docker run -d \
	-e VIRTUAL_HOST=front.ipose.makertim.nl \
	-p 8082:80 \
	-v /srv/production/front:/usr/local/apache2/htdocs/ \
	--name frontend \
	httpd

## Backend ##
docker run -d \
	-e VIRTUAL_HOST=back.ipose.makertim.nl \
	-p 8083:8080 \
	-v /srv/production/back:/opt/starter/run/ \
	--name backend \
	makertim/jarrunner
