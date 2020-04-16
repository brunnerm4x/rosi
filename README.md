# ROSI

## Realtime Online Streaming with IOTA

### Links to the repositories

#### Main Project
* client: https://github.com/brunnerm4x/rosi-client
* conserver: https://github.com/brunnerm4x/rosi-conserver
* payserver: https://github.com/brunnerm4x/rosi-payserver
* walletserver: https://github.com/brunnerm4x/rosi-walletserver
#### Demo
* audiostream: https://github.com/brunnerm4x/rosi-audiostream
* faucet: https://github.com/brunnerm4x/rosi-faucet


### Description
This project aims to be a working proof that anonymous paying on demand with a cryptocurrency works and even more is suitable for the "average" user.
IOTA is the perfect currency for that usecase, as it has zero fees (for microtransactions), is quite fast, and has good developer documentation
and client libraries.

ROSI utilizes the proposed Flash-Channels for fast payments every few seconds.
The flash channel lib of the IOTA Foundation is used, but it is very limited and there are some extensions and
additions used so this project is not 100% compatible concerning flash channels to the original
(for more on this see comments in the scripts).

The project consists of server and client parts and is organized in multiple repositories.

### Components

This repository is only home to some documentation and the project website. The product is splitted up in mulitple 
repositories, a small introduction of those parts can be found below.

#### Browser-Addon: rosi-client 

The main client is a webextension / browser add-on for FireFox. It manages everything for the user side. 
It is designed to do most of the work autonomously - the user just has to use sensible settings.
Everything it does is strictly predefined and easy to understand - the user should always
know why everything happens. It is designed to protect the privacy of the user at all circumstances - not a single
request to another server is not absolutely necessary. There is NO NEED for an ACCOUNT at any form.
The user has the possibility to create a BACKUP Account (not neccessary for the function of the system) - for
that he can use an external provider to store the backup - which is encoded with the password on the client
PC and sent encrypted. Everybody can also host his own backup server - it is very lightweight (rosiConserver).


#### Website / Provider Interface: rosi-audiostream

The website has to start the communication with the plugin - a lib to simplify this is part of this project (rosicomm.js)
The website has to request a connection with the provider name (every content provider can choose a name). 
For each stream it has to define a maximum price per minute that it must not exceed (then no payments are accepted by the plugin).

rosi-audiostream should just be an example - ROSI needs usage to get useful ;)


#### Provider Payserver: rosi-payserver 

This is the server that manages payments on the flash channels. It creates, closes, and sends payments
on channels.


#### Provider Walletserver: rosi-walletserver

This server hosts a wallet to provide storage of received iotas and also provides new addresses and some utility functions.


#### Backup Server: rosi-conserver 
This is the backup server for user backups. The browser is not the ideal place to store data for a longer period, there
are many possibilities that delete data, a backup is therefore essential. rosi-conserver addresses this issue in a simple 
manner. In a later state of the project a system daemon instead of the heavy addon could be an improvement on both 
performance and data security.



### Try It Now
A first version can be tried out today! There are signed (from Mozilla) Addon-Files (must be signed to be able to be installed
in standard Firefox Versions), a working website and even a IOTA Faucet for those who don't have some spare IOTAs accessable.
Just go to https://rosipay.net for more information and links.


### Setup

Normal user getting-started guide is on https://rosipay.net. 

If you want to build the software yourself and play around with it, go to the rosi-* repositories and you will find 
instructions in the READMEs.


### Automatic Server Setup Script

There is a possibility to set up ROSI-Servers with the help of an interactive install script (`automatic_server_setup.sh`).
Certain Packages are needed to be installed beforehand: wget, git, nodeJs (npm, node), Qt (qmake, only if you want rosi-conserver), pm2 (via npm, only if you want that process manager).

The script will try to install missing packages using apt & npm. If that fails it is required to install these manually.
The script is made on/for Debian, so there might be some changes necessary to get it working on other systems.

1. Open Terminal and cd to Folder where you want to install the servers.
2. Get the automatic install script (you can also clone this repository if you want): `wget https://raw.githubusercontent.com/brunnerm4x/rosi/master/automatic_server_setup.sh`
3. Start it: `chmod +x automatic_server_setup.sh && ./automatic_server_setup.sh`
4. It should guide you through the installation process. If you want to configure something, please go to the respective repository readme.






