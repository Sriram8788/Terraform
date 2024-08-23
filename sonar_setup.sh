sudo apt update

sudo apt upgrade -y

sudo apt install -y openjdk-17-jdk

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget -q -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/postgresql.asc

sudo apt install postgresql postgresql-contrib -y

sudo systemctl enable postgresql

sudo systemctl start postgresql

sudo systemctl status postgresql

sudo -i -u postgres

createuser sonardb

psql

ALTER USER sonardb WITH ENCRYPTED password 'Ram*2024';

CREATE DATABASE sonarqube_database OWNER sonardb;

GRANT ALL PRIVILEGES ON DATABASE sonarqube_database to sonardb;

exit

sudo apt install zip -y

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip

sudo unzip sonarqube-10.0.0.68432.zip

sudo mv sonarqube-10.0.0.68432 SonarQube

sudo mv sonarqube /opt/

sudo groupadd sonargr

sudo useradd -d /opt/sonarqube -g sonargr sonar

sudo chown sonar:sonargr /opt/sonarqube -R

sudo nano /opt/sonarqube/conf/sonar.properties

<<-COMMENT
7) Configure SonarQube
i) Edit the SonarQube configuration file.

sudo nano /opt/sonarqube/conf/sonar.properties
a) Find the following lines:

#sonar.jdbc.username=

#sonar.jdbc.password=

b) Uncomment the lines, and add the database user and Database password you created in Step 4 (xi and xii). For me, it’s:

sonar.jdbc.username=sonardb

sonar.jdbc.password=Ram*2024

c) Below these two lines, add the following line of code.

sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube_database
d) Save and exit the file.

ii) Edit the sonar script file.

sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
a) Add the following line

RUN_AS_USER=sonar
b) Save and exit the file.

8) Setup Systemd service
i) Create a systemd service file to start SonarQube at system boot.

sudo nano /etc/systemd/system/sonar.service
ii) Paste the following lines to the file.

[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonargr
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
[Install]
WantedBy=multi-user.target
iii) Save and exit the file.

iv) Enable the SonarQube service to run at system startup.
sudo systemctl enable sonar

v) Start the SonarQube service.
sudo systemctl start sonar

vi) Check the service status.
sudo systemctl status sonar

9) Modify Kernel System Limits
SonarQube uses Elasticsearch to store its indices in an MMap FS directory. It requires some changes to the system defaults.

i) Edit the sysctl configuration file.
sudo nano /etc/sysctl.conf

ii) Add the following lines.
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

iii) Save and exit the file.

iv) Reboot the system to apply the changes.
sudo reboot
COMMENT
