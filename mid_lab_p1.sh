#!/bin/bash

clear
echo -e "/////FIRST PART OF MIDDLE LAB IN DEVOPS COURSE/////\n=============================================================\n
this script will automaally do he following steps
1. Create an nginx dockerfile
2. execute the dockerfile into an image named - net4u_nginx
3. Deploy a container from net4u_nginx image
4. Run health check for the container checking the http port
5. Upload the image to DockerHub
============================================================="
sleep 3
echo -e "\nstarting step 1 -Checking pre-requisits for docker installation on this machine (ubuntu 18.04)\n"

if [[ $(which curl) && $(curl --version) ]];
then
  echo -e "proceeding++++++++++\n"
  # command
else
  echo "Installing curl"
 sudo apt-get install curl
  # command
fi


if [[ $(which docker) && $(docker --version) ]];
then
  echo "Update docker"
  # command
else
  echo "Installing docker"
  sudo curl -fsSL https://get.docker.com -o get-docker.sh
  sudo bash get-docker.sh
 echo "DONE INSTALLING"
  # command
fi

####Part 1. Create an nginx dockerfile####

echo -e "Getting nginx image\n++++++++++++++++++++++++++++++++++++\n"
sleep 1
sudo docker pull nginx:latest

a=0
while ((a==0))
do
  echo "What port do you want to assign for this container?"
  read pn
  path=`sudo pwd`
  resp=`netstat -tunl | grep ":$pn"`
  if [ -z "$resp" ]
  then
		((a++))
    echo -e "creating nginx container with acess port number $pn\n"
    sudo docker run -d -p $pn:80 -v $path:/usr/share/nginx/html nginx
		echo -e "Creating Docker done\n===============END PART 1================\n"
    sleep 2
  else
		echo "Port $pn is not free"
  fi
done
   
####Part 2. execute the dockerfile into an image####

did=`sudo docker ps -a | awk 'NR==2 {print $1}'`
sudo docker commit "$did" net4u_nginx:latest

path=`sudo pwd`
echo "<h1>A RUNNING CONTAINER<h1>" >> $path/index.html
echo -e "\n===============END PART 2================\n"
sleep 2


#####Part 3. Deploy a container from net4u_nginx image#####

i=0
while ((i==0))
  do
    echo "What port do you want to assign for this net4u_nginx container?"
    read pn
    path=`sudo pwd`
    resp=`netstat -tunl | grep ":$pn"`
    if [ -z "$resp" ]
    then
    	((i++))
      echo -e "creating net4u_nginx container with acess port number $pn\n"
      sudo docker run -d -p $pn:80 -v $path:/usr/share/nginx/html net4u_nginx
    	echo -e "Creating Docker from image done\n===============END PART 3================\n"
      echo "$i"
      sleep 2
    else
  		echo "Port $pn is not free"
    fi
  done

#####Part 4. Run health check for the container checking the http port#####

status=`sudo docker ps -a | grep net4u_nginx | awk '{print $7}'`
echo "$status"
if [ $status == "Exited" ]
then
  echo "Docker is not functioning.... exiting"
  exit
else
  echo "Docker is connected with port $pn"  
fi    
PN=`sudo docker ps -a | awk 'NR==2 {print $11}' | cut -c 4-7`
echo "$PN"
timeout 1s curl -v telnet://localhost:$PN 

echo -e "\n===============END PART 4================\n"
sleep 2


#####Part 5. Upload the image to DockerHub#####

cat ~/mid_lab/my_password.txt | sudo docker login --username hweber01 --password-stdin
ID=`sudo docker ps -a | grep net4u_nginx | awk '{print $1}'`
sudo docker commit $ID hweber01/net4u_nginx:latest
#sudo docker tag nginx_net4u:hweber01/devops
sudo docker image push hweber01/net4u_nginx:latest
echo -e "image uploaded\n===============END PART 5================\n"
sleep 2
echo -e "==============END NIDDLE LAB FIRST PART==============="

