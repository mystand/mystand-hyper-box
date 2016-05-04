#!/usr/bin/env bash
# Updating packages
echo ">>> Adding RVM key"
su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3' >/dev/null 2>&1
# Updating packages
echo ">>> Updating packages"
apt-get update >/dev/null 2>&1
echo ">>> Installing build-essential" 
apt-get install -y build-essential >/dev/null 2>&1
echo ">>> Installing RVM (it will take 5-10 minutes)"
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby' >/dev/null 2>&1 
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles' >/dev/null 2>&1
su - vagrant -c 'source ~/.rvm/scripts/rvm' >/dev/null 2>&1
echo ">>> Installing Bundler"
su - vagrant -c 'gem install bundle' >/dev/null 2>&1
echo ">>> Installing Git"
apt-get install -y git >/dev/null 2>&1
echo ">>> Installing SQLite"
apt-get install -y sqlite3 libsqlite3-dev >/dev/null 2>&1
echo ">>> Installing Redis"
apt-get install -y redis-server >/dev/null 2>&1 
echo ">>> Installing Node.js"
apt-get install -y nodejs nodejs-legacy npm>/dev/null 2>&1
echo ">>> Installing PostgreSQL"
apt-get install -y postgresql postgresql-contrib libpq-dev >/dev/null 2>&1
sudo -u postgres createuser --superuser vagrant >/dev/null 2>&1
echo ">>> Installing Imagemagick"
apt-get install -y imagemagick >/dev/null 2>&1
echo ">>> Successful completed"


