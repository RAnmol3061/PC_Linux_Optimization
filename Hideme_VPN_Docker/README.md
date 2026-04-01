## How to use this dockerfile

Put all these files inside one folder, let's say 'Hideme'
- Dockerfile
- docker-compose.yml
- entrypoint.sh

Create a .env file inside Hideme Folder and make these entries

VPN_USER='Your Username'

VPN_PASS='Your Password'

VPN_LOCAL_RANGE=<Your IP Range>



Create a folder named "data" inside the folder

After the setup run the following command in sequence

1) docker compose build 
2) docker compose up -d #Run without -d if you want to see the logs

To stop the container run
docker stop vpn-gateway