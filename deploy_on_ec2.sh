sudo apt-get update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash  # install nvm
source ~/.bashrc
nvm install node  # install node
npm install -g pm2  # install pm2
sudo apt-get install -y nginx  # install nginx

sudo echo \
"server {
        listen 80;
        server_name 54.225.67.228;

        location / {
                proxy_pass http://localhost:3000;
        }

        location /api/ {
                proxy_pass http://localhost:8080;
        }
}" \
/etc/nginx/sites-available/devops-code-challenge

sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/devops-code-challenge /etc/nginx/sites-enabled/
ls /etc/nginx/sites-enabled/ -l
sudo systemctl restart nginx

cd ~/devops-code-challenge/backend
npm ci
pm2 start npm --name "backend" -- start

cd ~/devops-code-challenge/frontend
npm ci
pm2 start npm --name "frontend" -- start
