# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}
#Add ppa keys
echo updating package information

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 >/dev/null 2>&1
(echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list) >/dev/null 2>&1

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
(echo "deb http://packages.elastic.co/elasticsearch/2.1/debian stable main" | sudo tee /etc/apt/sources.list.d/elasticsearch.list) >/dev/null 2>&1

sudo add-apt-repository ppa:webupd8team/java -y >/dev/null 2>&1

su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
sudo apt-get -y update >/dev/null 2>&1
#Adding ppa keys complete

install 'development tools' build-essential

echo "installing RVM"
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby'  >/dev/null 2>&1
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'  >/dev/null 2>&1

# node
echo "installing NVM"
su - vagrant -c 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash' >/dev/null 2>&1
su - vagrant -c 'nvm install 0.12.7' >/dev/null 2>&1
su - vagrant -c 'nvm alias default 0.12.7' >/dev/null 2>&1

install Git git
install SQLite sqlite3 libsqlite3-dev
install memcached memcached
install Redis redis-server
install nodejs

#Installing MongoDB
sudo apt-get -y install mongodb-org >/dev/null 2>&1 

#Installing PostgreSQL
install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'rails'@'localhost';
CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
echo "installing Postgis"
sudo apt-get install -y postgis postgresql-9.4-postgis-2.1

#Installing Elasticsearch
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

echo "installing oracle-java8-installer"
sudo apt-get -y install oracle-java8-installer >/dev/null 2>&1
echo "installing Elasticsearch"
sudo apt-get -y --force-yes  install elasticsearch >/dev/null 2>&1

sudo update-rc.d elasticsearch defaults 95 10  >/dev/null 2>&1
sudo /etc/init.d/elasticsearch start  >/dev/null 2>&1

#Installing ImageMagick
install Imagemagick imagemagick

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'DALEK: EXTERMINATE!'
