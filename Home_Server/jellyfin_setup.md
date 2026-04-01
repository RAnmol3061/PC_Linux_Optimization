Allow port 8096 for jellyfin

I had to manually give permission to jellyfin for /mnt/jellyfin/Anime folder

sudo chown -R jellyfin:jellyfin /mnt/jellyfin/Anime
sudo chmod -R 755 /mnt/jellyfin/Anime


Even after doing all that, the episodes weren't showing in jellyfin
After going through logs I came to know that two things:

1) Connection request to metadata library was timing out due to poor DNS resolution by ISP
2) Permission to access internal folder was denied to jellyfin: /var/lib/jellyfin/data/playlists


To fix the above problems:
2) sudo chown -R jellyfin:jellyfin /var/lib/jellyfin 
   sudo chmod -R 755 /var/lib/jellyfin

I ran these two commands to give jellyfin permission to read/write in that folder

1) I switched from default DNS to Cloudflare DNS, also I use network manager so the commands used are given below:

# Set Cloudflare DNS
sudo nmcli connection modify "NAME" ipv4.dns "1.1.1.1 1.0.0.1" #Here replace "NAME" with your "SSID"

# Tell it to ignore your router's DNS (Force Cloudflare)
sudo nmcli connection modify "NAME" ipv4.ignore-auto-dns yes 

# Disable IPv6 because most isp ipv6 are broken
sudo nmcli connection modify "NAME" ipv6.method "disabled"

# Apply changes
sudo nmcli connection up "NAME"


After all these jellyfin worked well.

---------------x-------------------

Below are the steps I used to install sonarr using docker-compose, I am using sonarr to rename my files to jellyfin's regex
docker-compose.yml file is in docker/sonarr and I have created a docker/sonarr/config directory

docker-compose.yml
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000 # Replace with your 'id -u' if not 1000
      - PGID=1000 # Replace with your 'id -g' if not 1000
      - TZ=
    volumes:
      - ./config/sonarr:/config
      - /mnt/jellyfin/Anime:/Anime  
    ports:
      - 8989:8989
    restart: unless-stopped


Also setup ufw to allow 8989 port for docker/sonarr



