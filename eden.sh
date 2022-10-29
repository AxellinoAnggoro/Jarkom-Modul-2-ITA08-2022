echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update -y
apt-get install apache2 -y
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install wget -y
apt-get install unzip -y

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O FILENAME

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1S0XhL9ViYN7TyCj2W66BNEXQD2AAAw2e' -O wise.zip

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1q9g6nM85bW5T9f5yoyXtDqonUKKCHOTV' -O eden.wise.zip

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1bgd3B6VtDtVv2ouqyM8wLyZGzK5C9maT' -O strix.operation.wise.zip

unzip wise.zip
unzip eden.wise.zip
unzip strix.operation.wise.zip

cp 000-default.conf wise.ita08.com.conf

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.ita08.com
        ServerName wise.ita08.com
        ServerAlias www.wise.ita08.com

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

" > /var/www/wise.ita08.com

a2ensite wise.ita08.com

cp -r /root/wise /var/www/wise.ita08.com

echo "

<Directory /var/www/wise.ita08.com>
      Options +FollowSymLinks -Multiviews
      AllowOverride All
</Directory>
# AllowOverride All ditambahkan agar konfigurasi .htaccess dapat berjalan.
# +FollowSymLinks ditambahkan agar konfigurasi mod_rewrite dapat berjalan.
# -Multiviews ditambahkan agar konfigurasi mod_negotiation tidak dapat berjalan. mod_negotiation bisa 'rewrite' requests sehingga menimpa dan mengganggu mod_rewrite.

" > /etc/apache2/sites-available/wise.ita08.com.conf

a2enmod rewrite

echo "
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) /index.php/\$1 [L]
" > /var/www/wise.ita08.com/.htaccess

cp -r /etc/apache2/sites-available/wise.ita08.com.conf /etc/apache2/sites-available/eden.wise.ita08.com.conf

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.ita08.com
        ServerName eden.wise.ita08.com
        ServerAlias www.eden.wise.ita08.com

        <Directory /var/www/eden.wise.ita08.com>
                Options +FollowSymLinks -Multiviews
		            AllowOverride All
        </Directory>
		
		<Directory /var/www/eden.wise.ita08.com>
                Options +Indexes  +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
		
		Alias \"/js\" \"/var/www/eden.wise.ita08.com/public/js\"

		<Directory /var/www/eden.wise.ita08.com>
                Options +Indexes  +FollowSymLinks -Multiviews
                AllowOverride All
		</Directory>

		Alias \"/js\" \"/var/www/eden.wise.ita08.com/public/js\"


        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

"> /etc/apache2/sites-available/eden.wise.ita08.com.conf

a2ensite eden.wise.ita08.com 

cp -r /root/eden.wise /var/www/eden.wise.ita08.com

echo "
ErrorDocument 404 /error/404.html
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^public/images/.*eden.*\$ public/images/eden.png [NC,L]
"> /var/www/eden.wise.ita08.com/.htaccess

cp -r /root/eden.wise /var/www/eden.wise.ita08.com

cp /etc/apache2/sites-available/eden.wise.ita08.com.conf /etc/apache2/sites-available/strix.operation.wise.ita08.com.conf

echo "
<VirtualHost *:15000>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita08.com
        ServerName strix.operation.wise.ita08.com
        ServerAlias www.strix.operation.wise.ita08.com

        <Directory \"/var/www/strix.operation.wise.ita08.com\">
                AuthType Basic
                AuthName \"Restricted Content\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<VirtualHost *:15500>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita08.com
        ServerName strix.operation.wise.ita08.com
        ServerAlias www.strix.operation.wise.ita08.com

        <Directory \"/var/www/strix.operation.wise.ita08.com\">
                AuthType Basic
                AuthName \"Restricted Content\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# Creds
username Twilight 
password opStrix

# Set Creds
htpasswd -c /etc/apache2/.htpasswd Twilight
htpasswd -b -c /var/www/.htpasswd Twilight opStrix

"> /etc/apache2/sites-available/strix.operation.wise.ita08.com.conf

a2ensite strix.operation.wise.ita08.com

cp -r /root/strix.operation.wise /var/www/strix.operation.wise.ita08.co

echo "
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 15000
Listen 15500

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
"> /etc/apache2/ports.conf

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        Redirect 301 / http://www.wise.ita08.com


        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

"> /etc/apache2/sites-available/000-default.conf

service apache2 restart









