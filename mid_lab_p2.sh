#!/bin/bash

clear
echo -e "/////SECOND PART OF MIDDLE LAB IN DEVOPS COURSE/////\n=============================================================\n
this script will automaally do he following steps
1. pull net4u image from dockerhub
2. execute a menu script
3. Deploy 3 containers
4. check container from browser
5. Upload the entire middle lab to GitHub
============================================================="
sleep 3

#####Part 1. pull net4u image from dockerhub#####

cat ~/mid_lab/my_password.txt | sudo docker login --username hweber01 --password-stdin
sudo docker pull hweber01/net4u_nginx:latest
echo -e "net4u_nginx image downloaded from Dockerhub\n===============END PART 1================\n"
sleep 2

#####Part 2. execute a menu script#####

#!/bin/bash

clear
while [ True ]
do
  echo -e "please choose one of the following options:
  		1. Download docker images
  		2. deploy containers
  		3. Start cottainers
  		4. Stop containers
  		5. Remove all images
  		6. Quit\n==========="
  read di
  
  if [ $di == 1 ]
  then
    run=0
    while ((run==0))
    do
      echo -e "choose docker images to download:\nphp\ncentos\nubuntu\nnginx\n===> "
      read image
  	
      if [ $image ==  "php" ] ||	[ $image == "centos" ] || [ $image == "ubuntu" ] || [ $image == "nginx" ]
      then
        echo -e "Getting $image image"
        sudo docker pull $image:latest
        ask=0
        while ((ask==0))  
        do
          echo -e "do you want to download anoother image?: y/n"
          read c_choice
          if [ $c_choice == "y" ]
          then 
            break
          elif [ $c_choice == "n" ]
          then
            ((ask++)) ; ((run++))
          else
             echo "choose y or n"
          fi
        done
      else
        echo -e "Enter a valid image name!"
      fi 
    done
  elif [ $di == 2 ]
  then
    echo -e "This is the list of images available on this machine:\n`sudo docker images | awk '{print$1}'`\nplease select one to deploy"
    read image
    #check=0
   #while ((check==0))
    #do
        echo "How many $image containers do you want to create?"
    		read nc
    		i=1
    		for i in $(seq 1 $nc)
    		do
          echo "What port do you want to assign for $image container #$i?"
          read pn
          resp=`netstat -tunl | grep ":$pn"`
          if [ -z "$resp" ]
          then
        		echo "creating $image container number $i"
            sudo docker run -d -p $pn:80 $image
        		((i++))
          else
        		echo "Port $pn is not free"
            if [ $i -gt 1 ]
          	then
              ((i--))
            fi
		      fi
    		done
    #done
  elif [ $di == 3 ]
  then
    echo "Starting all containers"
    sudo docker start $(sudo docker ps -a -q)
    
  elif [ $di == 4 ]
  then
    echo "Stopping all containers"
    sudo docker stop $(sudo docker ps -a -q)
  
  elif [ $di == 5 ]
  then
    echo "removing all images"
    sudo docker image prune --all --force
 
  elif [ $di == 6 ]
  then
    echo "Thank you, exiting"
    exit 0
  else
    echo "Enter a number between 1-6 only!"
  fi
done


echo -e "\n===============END PART 2================\n"

sleep 2

#####Part 3. Deploy 3 net4u image containers#####
        echo "How many net4u image containers do you want to create?"
        nc=3
    		i=1
    		for i in $(seq 1 $nc)
    		do
          echo "What port do you want to assign for net4u image container #$i?"
          read pn
          resp=`netstat -tunl | grep ":$pn"`
          if [ -z "$resp" ]
          then
        		echo "creating net4u image container number $i"
            sudo docker run -d -p $pn:80 $image
        		((i++))
          else
        		echo "Port $pn is not free"
            if [ $i -gt 1 ]
          	then
              ((i--))
            fi
		      fi
    		done
       
echo -e "\n===============END PART 3================\n"
sleep 2

#####Part 4. check container from browser#####

echo "DONE"


#####Part 5. Upload the entire middle lab to GitHub#####

