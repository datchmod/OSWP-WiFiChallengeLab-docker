<p align="center">
  <img src="images/B-WifiChallengeLab-LOGO.png">
</p>

<p align="center">
   <a href="https://github.com/r4ulcl/WiFiChallengeLab-docker/releases">
    <img src="https://img.shields.io/github/v/release/r4ulcl/WiFiChallengeLab-docker" alt="GitHub releases">
  </a>
  <a href="https://github.com/r4ulcl/WiFiChallengeLab-docker/stargazers">
    <img src="https://img.shields.io/github/stars/r4ulcl/WiFiChallengeLab-docker.svg?style=flat" alt="GitHub stars">
  </a>
  <a href="https://github.com/r4ulcl/WiFiChallengeLab-docker/network">
    <img src="https://img.shields.io/github/forks/r4ulcl/WiFiChallengeLab-docker.svg?style=flat" alt="GitHub forks">
  </a>
  <a href="https://github.com/r4ulcl/WiFiChallengeLab-docker/issues">
    <img src="https://img.shields.io/github/issues/r4ulcl/WiFiChallengeLab-docker.svg?style=flat" alt="GitHub issues">
  </a>
  <a href="https://github.com/r4ulcl/WiFiChallengeLab-docker/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/r4ulcl/WiFiChallengeLab-docker.svg?style=flat" alt="GitHub license">
  </a>
</p>


# WiFiChallengeLab-docker


[![Docker Image APs](https://github.com/r4ulcl/WiFiChallengeLab-docker/actions/workflows/docker-image-aps.yml/badge.svg)](https://hub.docker.com/r/r4ulcl/wifichallengelab-aps) [![Docker Image Clients](https://github.com/r4ulcl/WiFiChallengeLab-docker/actions/workflows/docker-image-clients.yml/badge.svg)](https://hub.docker.com/r/r4ulcl/wifichallengelab-clients)


Docker version of WiFiChallenge Lab with modifications in the challenges and improved stability. Ubuntu virtual machine with virtualized networks and clients to perform WiFi attacks on OPN, WPA2, WPA3 and Enterprise networks. 


## CTFd Lab

For direct access to download the VM and complete the challenges go to the CTFd web site: 

[WiFiChallenge Lab v2.0](https://wifichallengelab.com/)



## Changelog from version v1.0

The principal changes from version 1.0.5 to 2.0.3 are the following. 
- Remove Nested VMs. Replaced with Docker
- Add new attacks and modify the existent to make them more real
    - WPA3 bruteforce and downgrade
    - MGT Multiples APs
    - Real captive portal evasion (instead of just MAC filtering)
    - Phishing client with fake website.
- Eliminating the WPS pin attack as it is outdated, unrealistic, and overly simplistic.
- Use Ubuntu as SO instead of Debian
- Use vagrant to create the VM to be easy to replicate
- More Virtual WiFi adapters
    - More APs
    - More clients
- Monitorization and detection using nzyme WIDS.

## Using WiFiChallenge Lab

### Docker inside a Linux host or a custom VM

Download the repository and start the docker with the APs, the clients and nzyme for alerts. 

``` bash
git clone https://github.com/r4ulcl/WiFiChallengeLab-docker
cd WiFiChallengeLab-docker

sudo apt install docker.io
docker --version

sudo curl -L "https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
sudo docker-compose up -d  
```

#### Optionally: Install Wi-Fi tools

Go to the folder where the tools will be installed and execute `Attacker/installTools.sh`

### Attack from Ubuntu VM
- The tools are installed and can be found in the tools folder of the root home. 
- There are 7 antennas available, wlan0 to wlan6.
- Do not disturb mode can be disabled with the following command. 

### Attack from Host
- Start the docker-compose.yml file and use the virtual WLAN. 
- Use your own tools and configurations to attack. 

## Modify config files
To modify the files you can download the repository and edit both APs and clients (in the VM the path is /var/WiFiChallenge). The files are divided by APs, Clients, and Nzyme files.

## Recompile Docker
To recreate the Docker files with the changes made, modify the docker-compose.yml file by commenting out the "image:" line in each Docker and uncommenting the line with "build:". Then use "docker compose build" to create a new version.
