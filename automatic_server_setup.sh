#!/bin/bash

echo "This script helps to set up all or selected servers of the ROSI-Project. It is intended to be used on Debian-like system and may need to be changed to work on other system."

if ! [ -x "$(command -v sudo)" ]; then
  echo 'WARNING: sudo is not installed. This script will not be able to install any dependencies.'
fi

if ! [ -x "$(command -v wget)" ]; then
  echo 'WARNING: wget is not installed. Trying to install it using apt, please provide your sudo password if requested.'
  if ! sudo apt-get install wget; then
    echo "Could not install wget. Exiting." 
    exit 1;
  fi
fi

# Check if this repository has been cloned or just this file has been downloaded ..
if [ ! -f create-pm2config.js ] || [ ! -f pm2-rosi-servers.json ]; then
    echo "Getting needed setup scripts from github ... "
    wget https://raw.githubusercontent.com/brunnerm4x/rosi/master/create-pm2config.js
    wget https://raw.githubusercontent.com/brunnerm4x/rosi/master/pm2-rosi-servers.json
fi

echo "Checking required tools ... "

if ! [ -x "$(command -v git)" ]; then
  echo 'WARNING: git is not installed. Trying to install it using apt, please provide your sudo password if requested.'
  if ! sudo apt-get install git; then
    echo "Could not install git. Exiting." 
    exit 1;
  fi
fi

if ! [ -x "$(command -v node)" ]; then
  echo 'WARNING: nodejs is not installed or not added to system path. Trying to install it using apt, please provide your sudo password if requested.'
	if ! sudo apt-get install nodejs; then
    echo "Could not install nodejs. Exiting." 
    exit 1;
  fi
fi

if ! [ -x "$(command -v npm)" ]; then
  echo 'WARNING: npm is not installed or not added to system path. Trying to install it using apt, please provide your sudo password if requested.'
	if ! sudo apt-get install npm; then
    echo "Could not install npm. Exiting." 
    exit 1;
  fi
fi

echo
echo "Available Server packages:"

servers=("rosi-walletserver" "rosi-payserver" "rosi-conserver" "rosi-audiostream-streamserver" "rosi-audiostream-webserver" "rosi-faucet-wallet" "rosi-faucet-webserver")

selected=()
PS3='What Servers would you like to set up? You can select multiple space separated options: '
select server in "${servers[@]}" ; do
    for reply in $REPLY ; do
        selected+=(${servers[reply - 1]})
    done
    [[ $selected ]] && break
done
echo You selected to be installed: "${selected[@]}"

read -p "Continue with the installation of selected servers (y/n)?" choice
case "$choice" in 
  y|Y ) echo "OK, Continuing...";;
  n|N ) echo "Stopping the process"; exit;;
  * ) echo "Invalid Input, stopping."; exit;;
esac



echo "Downloading git repos ..."

# Install walletserver
if [[ " ${selected[*]} " == *" rosi-walletserver "* ]]; then
    echo "Installing rosi-walletserver ..."
    git clone -b master --single-branch https://github.com/brunnerm4x/rosi-walletserver.git
    cd rosi-walletserver/
    npm i
    echo "rosi-walletserver installed."
    cd ../
    echo
fi

# Install payserver
if [[ " ${selected[*]} " == *" rosi-payserver "* ]]; then
    echo "Installing rosi-payserver ..."
    git clone -b master --single-branch https://github.com/brunnerm4x/rosi-payserver.git
    cd rosi-payserver/
    npm i
    cd ../
    echo "rosi-payserver installed."
    echo
fi


# Install conserver
if [[ " ${selected[*]} " == *" rosi-conserver "* ]]; then
    echo "Installing rosi-conserver ..."
    
    if ! [ -x "$(command -v qmake)" ]; then
	  echo 'WARNING: qmake / qt is not installed or not added to system path. Trying to install it using apt, please provide your sudo password if requested.'
		if ! sudo apt-get install qt5-default; then
		echo "Could not install qt5-default. Exiting." 
		exit 1;
	  fi
	fi
	
	git clone -b master --single-branch https://github.com/brunnerm4x/rosi-conserver.git
	cd rosi-conserver/
	# using qmake in default path...
	export qmake=qmake
	chmod +x build.sh && ./build.sh
	cd ../
	echo "rosi-conserver installed."
    echo
fi


# Install audiostream
if [[ " ${selected[*]} " == *" rosi-audiostream-streamserver "* ]] || [[ " ${selected[*]} " == *" rosi-audiostream-webserver "* ]]; then
    echo "Installing rosi-audiostream ..."
    git clone -b master --single-branch https://github.com/brunnerm4x/rosi-audiostream.git
    cd rosi-audiostream/
    npm i
    cd ../
    echo "rosi-audiostream installed. Please note that you still have to add some content ;)"
    echo
fi


# Install payserver
if [[ " ${selected[*]} " == *" rosi-faucet-wallet "* ]] || [[ " ${selected[*]} " == *" rosi-faucet-webserver "* ]]; then
    echo "Installing rosi-faucet ..."
    git clone -b master --single-branch https://github.com/brunnerm4x/rosi-faucet.git
    cd rosi-faucet/
    npm i
    cd ../
    echo "rosi-faucet installed."
    echo
fi




# SETUP PM2

read -p "Setup PM2 for your servers (y/n)?" choice
case "$choice" in 
  y|Y ) echo "OK, Continuing...";;
  n|N ) echo "OK Finished."; exit;;
  * ) echo "OK Finished."; exit;;
esac


if ! [ -x "$(command -v pm2)" ]; then
  echo 'WARNING: pm2 is not installed or not added to system path. Trying to install it using npm, please provide your sudo password if requested.'
  if ! sudo npm i pm2 -g; then
    echo "Could not install git. Exiting." 
    exit 1;
  fi
fi


# Create config file ...
node create-pm2config.js -- ${selected[@]}

# start pm2
pm2 start pm2-setup.json


echo "Added and started PM2 Processes. You can see them with command pm2 list or pm2 monit. To make sure to restart the daemons when system restarts, you can call pm2 startup and pm2 save to to save current list."
echo "Finished Setup."

