#Base Docker Directories
mkdir docker/data
mkdir docker/compose

##Specific Directories for Containers
#piholehome
mkdir docker/compose/homepihole
mkdir docker/data/homepihole
mkdir docker/data/homepihole/etc-pihole
mkdir docker/data/homepihole/etc-dnsmasq.d
mkdir docker/data/homepihole/var-log

root@cara:~# history
    1  vi /etc/network/interfaces
    2  reboot
    3  apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
    4  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    5  add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
    6  apt update
    7  apt -y install docker-ce docker-ce-cli containerd.io
    8  apt -y install docker-compose
    9  docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /:/host --restart always -e EDGE=1 -e EDGE_ID=1622ded7-1280-4e7f-9a74-bc21a9c63cc4 -e EDGE_KEY=aHR0cDovLzEwLjEuMC4yNDg6OTAwMHwxMC4xLjAuMjQ4OjgwMDB8MDE6YmE6NTg6MDY6NGY6ZDU6MDY6OGE6NGQ6YzE6OWM6ZTY6YzQ6MzY6YmU6MGN8OA -e CAP_HOST_MANAGEMENT=1 -p 8000:80 -v portainer_agent_data:/data --name portainer_edge_agent portainer/agent
   10  docker ps
   11  docker-compose list
   12  docker-compose ps
   13  ls
   14  pwd
   15  mkdir docker/data
   16  mkdir docker/compose
   17  mkdir docker/compose/homepihole
   18  mkdir docker/data/homepihole
   19  mkdir docker/data/homepihole/etc-pihole
   20  mkdir docker/data/homepihole/etc-dnsmasq.d
   21  mkdir docker/data/homepihole/var-log
   22  touch /root/docker/data/homepihole/var-log/pihole.log
   23  vi docker/compose/homepihole/piholehomedocker.yml
   24  docker-compose -f docker/compose/homepihole/piholehomedocker.yml up
   25  docker ps
   26  docker-compose -f docker/compose/homepihole/piholehomedocker.yml up
   27  docker-compose -f docker/compose/homepihole/piholehomedocker.yml down
   28  vi docker/compose/homepihole/piholehomedocker.yml
   29  docker-compose -f docker/compose/homepihole/piholehomedocker.yml up
   30  docker-compose -f docker/compose/homepihole/piholehomedocker.yml down
   31  cat /root/docker/compose/homepihole/piholehomedocker.yml 
   32  nslookup
   33  ping google.com
   34  rm /root/docker/data/homepihole/etc-dnsmasq.d/01-pihole.conf 
   35  rm /root/docker/data/homepihole/etc-pihole/*
   36  rm /root/docker/data/homepihole/var-log/pihole.log
   37  rm -fR /root/docker/data/homepihole/var-log/pihole.log/
   38  touch /root/docker/data/homepihole/var-log/pihole.log
   39  docker-compose -f docker/compose/homepihole/piholehomedocker.yml up
   40  docker-compose -f docker/compose/homepihole/piholehomedocker.yml down
   41  cat docker/compose/homepihole/piholehomedocker.yml
   42  docker ps
   43  history