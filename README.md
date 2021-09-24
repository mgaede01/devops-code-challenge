# Overview
This repository contains a React frontend, and an Express backend that the frontend connects to.

# Objective
Deploy the frontend and backend to somewhere publicly accessible over the internet. The AWS Free Tier should be more than sufficient to run this project, but you may use any platform and tooling you'd like for your solution.

Fork this repo as a base. You may change any code in this repository to suit the infrastructure you build in this code challenge.

# Submission
1. A github repo that has been forked from this repo with all your code.
2. Modify this README file with instructions for:
* Any tools needed to deploy your infrastructure
* All the steps needed to repeat your deployment process
* URLs to the your deployed frontend.

# Evaluation
You will be evaluated on the ease to replicate your infrastructure. This is a combination of quality of the instructions, as well as any scripts to automate the overall setup process.

# Setup your environment
Install nodejs. Binaries and installers can be found on nodejs.org.
https://nodejs.org/en/download/

For macOS or Linux, Nodejs can usually be found in your preferred package manager.
https://nodejs.org/en/download/package-manager/

Depending on the Linux distribution, the Node Package Manager `npm` may need to be installed separately.

# Running the project
The backend and the frontend will need to run on separate processes. The backend should be started first.
```
cd backend
npm ci
npm start
```
The backend should response to a GET request on `localhost:8080`.

With the backend started, the frontend can be started.
```
cd frontend
npm ci
npm start
```
The frontend can be accessed at `localhost:3000`. If the frontend successfully connects to the backend, a message saying "SUCCESS" followed by a guid should be displayed on the screen.  If the connection failed, an error message will be displayed on the screen.

# Configuration
The frontend has a configuration file at `frontend/src/config.js` that defines the URL to call the backend. This URL is used on `frontend/src/App.js#12`, where the front end will make the GET call during the initial load of the page.

The backend has a configuration file at `backend/config.js` that defines the host that the frontend will be calling from. This URL is used in the `Access-Control-Allow-Origin` CORS header, read in `backend/index.js#14`

# Optional Extras
The core requirement for this challenge is to get the provided application up and running for consumption over the public internet. That being said, there are some opportunities in this code challenge to demonstrate your skill sets that are above and beyond the core requirement.

A few examples of extras for this coding challenge:
1. Dockerizing the application
2. Scripts to set up the infrastructure
3. Providing a pipeline for the application deployment
4. Running the application in a serverless environment

This is not an exhaustive list of extra features that could be added to this code challenge. At the end of the day, this section is for you to demonstrate any skills you want to show that’s not captured in the core requirement.

# Tools Needed
1. EC2
2. Elastic IP
3. Terminal to SSH from (I used WSL Ubuntu)
4. pm2 (for node processes)
5. nginx (reverse proxy)

# Deployment Steps

Start by going to AWS and creating a new EC2 instance. Create a new security group with the following rules:
- SSH allowed only from your PC
- HTTP (port 80) allowed from any address 

Create an access key save to local machine

Create an Elastic IP in AWS and associate it with your new EC2 instance.
In a terminal, ssh into the new instance with the command `ssh -i keyname.pem ubuntu@<ELASTICIP ADDRESS>` and type yes to continue connecting.

Update packages that may need it
```
sudo apt-get update
```

Use these commands to install tools needed
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash # install nvm
source ~/.bashrc
nvm install node # install node
npm install -g pm2 # install pm2
sudo apt-get install -y nginx # install nginx
```

Configure Nginx
```

sudo touch /etc/nginx/sites-available/devops-code-challenge
echo \
"server {
        listen 80;
        server_name 54.225.67.228;

        location / {
                proxy_pass http://localhost:3000;
        }

        location /api/ {
                proxy_pass http://localhost:8080;
        }
}" | \
sudo tee -a /etc/nginx/sites-available/devops-code-challenge
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/devops-code-challenge /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Clone the application repo
```
git clone https://github.com/mgaede01/devops-code-challenge.git
```

Start the backend and frontend processes
```
cd ~/devops-code-challenge/backend
npm ci
pm2 start npm --name "backend" -- start

cd ~/devops-code-challenge/frontend
npm ci
pm2 start npm --name "frontend" -- start
```
Go to http://[ELASTICIP ADDRESS] for frontend and http://[ELASTICIP ADDRESS]/api for backend.

# My Deployed Application
Frontend: http://34.234.230.102/
Backend: http://34.234.230.102/api


