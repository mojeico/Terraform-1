#! /bin/bash
yum -y  update
yum -y  install httpd
echo "The page was created by the user data" >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on