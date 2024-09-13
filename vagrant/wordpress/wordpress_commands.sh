#dependencies
sudo apt update -y
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip -y

# create directory
sudo mkdir -p /srv/www
#change owner
sudo chown www-data: /srv/www
#use wordpress version from wordpress themselfs not the repo
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

#Create /etc/apache2/sites-available/wordpress.conf with following lines:
echo "<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/wordpress.conf


#Enable the site with:

sudo a2ensite wordpress

#Enable URL rewriting with:

sudo a2enmod rewrite

#Disable the default “It Works” site with:

sudo a2dissite 000-default

#restart the service
sudo service apache2 reload

#configure mysql database
#login to the database as root
sudo mysql -u root

# create new wordpress database
CREATE DATABASE wordpress;

#create database user for wordpress
CREATE USER wordpress@localhost IDENTIFIED BY '123'; #BAD PRACTICE THIS IS JUST FOR LEARNIGN

#grant rights to new user
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;

#apply changes
FLUSH PRIVILEGES;

#start the database service
sudo service mysql start

# make wordpress work with the database
#copy sample configuration
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

#add credentials and password to database (only edit password line if needed)
sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/wordpress/' /srv/www/wordpress/wp-config.php
# sudo -u www-data sed -i 's/password_here/<your-password>/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/123/' /srv/www/wordpress/wp-config.php

#we need randomized secrets to secure the site
# go to 
sudo -u www-data vi /srv/www/wordpress/wp-config.php
#replace all of
#define( 'AUTH_KEY',         'put your unique phrase here' );
# define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
# define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
# define( 'NONCE_KEY',        'put your unique phrase here' );
# define( 'AUTH_SALT',        'put your unique phrase here' );
# define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
# define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
# define( 'NONCE_SALT',       'put your unique phrase here' );
#with new lines from:
#https://api.wordpress.org/secret-key/1.1/salt/
















