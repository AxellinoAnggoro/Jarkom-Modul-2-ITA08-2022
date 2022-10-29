# Jarkom-Modul-2-ITA08-2022

Pengerjaan soal shift jarkom modul 2 oleh ITA08

# Anggota

| Nama                           | NRP          | 
| -------------------------------| -------------| 
| Axellino Anggoro A.              | `5027201040` | 
| Mutiara Nuraisyah Dinda R            | `5027201054` | 
| Brilianti Puspita S.  | `5027201070` |

## Soal 1
WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet 

### Penyelesaian : 
1. Pertama buat topologi sesuai contoh pada soal dan ubah namanya sesuai soal sebagai berikut:
![topologi](img/soal_1/1-topologi.png)

2. Konfigurasi masing-masing node sebagai berikut agar dapat mengakses internet
   - Ostania 
    ```
    auto eth1
    iface eth1 inet static
        address 192.213.1.1
        netmask 255.255.255.0

    auto eth2
    iface eth2 inet static
        address 192.213.2.1
        netmask 255.255.255.0

    auto eth3
    iface eth3 inet static
        address 192.213.3.1
        netmask 255.255.255.0
    ```
    - WISE
    ```
    auto eth0
    iface eth0 inet static
        address 192.213.3.2
        netmask 255.255.255.0
        gateway 192.213.3.1
    ```
    - SSS
    ```
    auto eth0
    iface eth0 inet static
        address 192.213.1.2
        netmask 255.255.255.0
        gateway 192.213.1.1
    ```
    - Garden
    ```
    auto eth0
    iface eth0 inet static
        address 192.213.1.3
        netmask 255.255.255.0
        gateway 192.213.1.1
    ```
    - Berlint
    ```
    auto eth0
    iface eth0 inet static
        address 192.213.2.2
        netmask 255.255.255.0
        gateway 192.213.2.1
    ```
    - Eden
    ```
    auto eth0
    iface eth0 inet static
        address 192.213.2.3
        netmask 255.255.255.0
        gateway 192.213.2.1
    ```

3. Konfigurasi lalu lintas data dari router `Ostania` menggunakan command `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.213.0.0/16`. 

### Testing
Selanjutnya masukkan command `echo nameserver 192.168.122.1 > /etc/resolv.conf` ke node `WISE, SSS, Garden, Berlint, Eden` sehingga setiap node sekarang sudah dapat mengakses internet
   - WISE
    ![wise](img/soal_1/1-wise.png)
   - SSS
    ![sss](img/soal_1/1-sss.png)
   - Garden
    ![garden](img/soal_1/1-garden.png)
   - Berlint
    ![berlint](img/soal_1/1-berlint.png)
   - Eden
    ![eden](img/soal_1/1-eden.png)

## Soal 2
Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.ita08.com dengan alias www.wise.ita08.com pada folder wise

### Penyelesaian :
#### WISE
1. Install bind9 pada DNS Master
    ```
    apt-get update
    apt-get install bind9 -y
    ```

2. Tambahkan konfigurasi domain wise.ita08.com dengan command `nano /etc/bind/named.conf.local` kemudian tambahkan script berikut:
   ```
    zone "wise.ita08.com" {
        type master;
        file "/etc/bind/wise/wise.ita08.com";
    };
   ```

3. Buat folder wise dengan command `mkdir /etc/bind/wise` kemudian copy `/etc/bind/db.local` ke `/etc/bind/wise/wise.ita08.com` 

4. Kemudian edit konfigurasi dari file `wise.ita08.com` sebagai berikut:
    ![wise-conf](img/soal_2/conf-wise.png)

#### Client Garden dan SSS
Arahkan nameserver ke ip router *WISE* sebagai berikut:
   ```
    nameserver 192.213.3.2 #IP Wise
   ```

### Testing
Ping domain `wise.ita08.com` menggunakan command `ping wise.ita08.com`
    ![garden-ping](img/soal_2/ping-garden.png)
    ![sss-ping](img/soal_2/ping-sss.png)

## Soal 3
Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden
### Penyelesaian
#### Wise
Tambahkan 3 line baru pada ```/etc/bind/wise/wise.ita08.com``` dengan kode seperti dibawah ini 
```
www             IN      CNAME   wise.ita08.com.
eden            IN      A       192.213.2.3 ;IP Eden
www.eden        IN      CNAME   eden.wise.ita08.com.
```

### Testing
#### Client SSS atau Garden
Jika sudah selesai bisa langsung dilakukan testing dengan perintah 

```ping eden.wise.ita08.com```

- Garden
    ![ping-eden-wise-garden](img/ping-eden-wise-garden.png)
- SSS
    ![ping-eden-wise-sss](img/ping-eden-wise-sss.png)
<br>

## Soal 4
Buat juga reverse domain untuk domain utama.
### Penyelesaian
#### Wise
Tambahkan kode zone baru pada ```/etc/bind/named.conf.local```
```
zone \"3.213.192.in-addr.arpa\" {
	type master;
	file \"/etc/bind/wise/3.213.192.in-addr.arpa\";
};
```
 Lalu mengcopy konfigurasi db.local dengan perintah seperti berikut ```cp /etc/bind/db.local /etc/bind/wise/3.213.192.in-addr.arpa```

 Kemudian ediy file konfigurasinya di ```/etc/bind/wise/3.213.192.in-addr.arpa```  menjadi seperti dibawah ini
```
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     wise.ita08.com. root.wise.ita08.com. (
                        2022102501              ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
3.213.192.in-addr.arpa.   IN      NS      wise.ita08.com.
2                         IN      PTR     wise.ita08.com
```

### Testing
#### Client SSS atau Garden
Install dnsutils dengan perintah ```apt-get update``` lalu ```apt-get install dnsutils -y``` setelah itu lakukan testing dengan ```host -t PTR 192.213.3.2```

- Garden
![hostPTR-garden](img/hostptr-garden.png)

- SSS
![hostPTR-sss](img/hostptr-sss.png)

<br>

## Soal 5
Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama
### Penyelesaian
#### Wise
Tambahkan 3 line baru pada ```/etc/bind/named.conf.local``` untuk mengkonfigurasi DNS Slave ke Berlint

```
notify yes;
	also-notify { 192.213.2.2; }; #IP Berlint
	allow-transfer { 192.213.2.2; }; #IP Berlint
```

```
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
zone \"wise.ita08.com\" {
	type master;
	notify yes;
	also-notify { 192.213.2.2; };
	allow-transfer { 192.213.2.2; };
	file \"/etc/bind/wise/wise.ita08.com\";
};

zone \"3.213.192.in-addr.arpa\" {
	type master;
	file \"/etc/bind/wise/3.213.192.in-addr.arpa\";
};
```
Lalu untuk melakukan testing DNS Slave berhasil di konfigurasi bind9 Wise harus dimatikan menggunakan perintah ```service bind9 stop```

### Testing
#### Berlint
Pastikan pada Berlint sudah menginstall bind9, jika belum dapat di install dengan perintah ```apt-get update``` dan ```apt-get install bind9 -y```
<br>
Tambahkan zone wise.ita08.com pada ```/etc/bind/named.conf.local``` dengan masters mengarah ke IP Wise

```
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone \"wise.ita08.com\" {
    type slave;
    masters { 192.213.3.2; }; // IP Wise
    file \"/var/lib/bind/wise.ita08.com\";
};

```
Kemudian jangan lupa untuk melakukan restart bind9 ```service bind9 restart ```
<br>
<img width="500" src="" />
<br>

### Testing
#### Client SSS atau Garden
Jika sudah menyalakan service bind9 pada Berlint dan mematikan bind9 pada Wise, lakukan ping pada server client SSS atau Garden

- Mematikan bind9 pada Wise
![stop-wise](img/stop-wise.png)

- Garden
![test-5-garden](img/test-no5-garden.png)

- SSS
![test-5-sss](img/test-no5-sss.png)

## Soal 6
Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation
### Penyelesaian
#### Wise
Tambahkan 2 line pada ```/etc/bind/wise/wise.ita08.com```
```
ns1             IN      A       192.213.2.2 ;IP Berlint
operation       IN      NS      ns1
```
```
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     wise.ita08.com. root.wise.ita08.com. (
                        2022102501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      wise.ita08.com.
@               IN      A       192.213.3.2 ;IP Wise
www             IN      CNAME   wise.ita08.com.
eden            IN      A       192.213.2.3 ;IP Eden
www.eden        IN      CNAME   eden.wise.ita08.com.
ns1             IN      A       192.213.2.2 ;IP Berlint
operation       IN      NS      ns1
```

Kemudian pada ```/etc/bind/named.conf.options```, jangan lupa untuk comment line ```dnssec-validation auto;``` dan tambahkan line ```allow-query{any;};``` dibawahnya menjadi seperti ini :

```
options {
        directory \"/var/cache/bind\";
        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113
        // If your ISP provided one or more IP addresses for stable 
        // nameservers, you probably want to use them as forwarders.  
        // Uncomment the following block, and insert the addresses replacing 
        // the all-0's placeholder.
        // forwarders {
        //      0.0.0.0;
        // };
        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
```
Kemudian restart bind9 ```service bind9 restart```
<br>
#### Berlint
Lakukan hal yang sama pada ```/etc/bind/named.conf.options```, comment line ```dnssec-validation auto;``` dan tambahkan line ```allow-query{any;};```

Lalu tambahkan kode zone untuk delegasi subdomain pada ```/etc/bind/named.conf.local``` seperti dibawah ini :

```
zone \"operation.wise.ita08.com\" {
    type master;
    file \"/etc/bind/operation/operation.wise.ita08.com\";
};
```

```
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone \"wise.ita08.com\" {
    type slave;
    masters { 192.213.3.2; }; // IP Wise
    file \"/var/lib/bind/wise.ita08.com\";
};

zone \"operation.wise.ita08.com\" {
    type master;
    file \"/etc/bind/operation/operation.wise.ita08.com\";
};
};
```

Lalu karena diminta untuk menyimpan di folder operation, maka buat folder baru dengan ```mkdir /etc/bind/operation```

<br>

Lalu mengcopy konfigurasi db.local dengan perintah seperti berikut ```cp /etc/bind/db.local /etc/bind/operation/operation.wise.ita08.com```

Kemudian edit file konfigurasinya di ```/etc/bind/operation/operation.wise.ita08.com```  menjadi seperti dibawah ini

```
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     operation.wise.ita08.com. root.operation.wise.ita08.com. (
                        2022102501              ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      operation.wise.ita08.com.
@       IN      A       192.213.2.3 ;IP Eden
www     IN      CNAME   operation.wise.ita08.com.
```
Kemudian restart bind9 ```service bind9 restart```

### Testing
#### Client Garden atau SSS
Lakukan testing dengan ```ping operation.wise.ita08.com```

- Garden
![ping-operation-garden](img/ping-operation-garden.png)

- SSS
![ping-operation-sss](img/ping-operation-sss.png)

## Soal 7
Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden 
### Penyelesaian
#### Berlint
Edit konfigurasi subdomain general pada ```/etc/bind/operation/operation.wise.ita08.com``` dengan menambahkan 2 line seperti dibawah ini

```
strix           IN      A       192.213.2.3 ;IP Eden
www.strix       IN      CNAME   strix.operation.wise.ita08.com.
```

```
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     operation.wise.ita08.com. root.operation.wise.ita08.com. (
                        2022102501              ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      operation.wise.ita08.com.
@       IN      A       192.213.2.3 ;IP Eden
www     IN      CNAME   operation.wise.ita08.com.
strix           IN      A       192.213.2.3 ;IP Eden
www.strix       IN      CNAME   strix.operation.wise.ita08.com.

```

Kemudian restart bind9 ```service bind9 restart```

### Testing
#### Client Garden atau SSS
Bisa dicoba dengan melakukan testing pada client server Garden atau SSS dengan perintah ```ping strix.operation.wise.ita08.com```

- Garden
![ping-strix-garden](img/ping-strix-garden.png)

- SSS
![ping-strix-sss](img/ping-strix-sss.png)

## Soal 8
Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver www.wise.yyy.com. Pertama, Loid membutuhkan webserver dengan DocumentRoot pada /var/www/wise.yyy.com

### Penyelesaian
#### WISE
Ubah konfigurasi dari record A dan PTR pada node wise agar mengarah ke ip eden sebagai berikut
   ```
    $TTL    604800
    @       IN      SOA     wise.ita08.com. root.wise.ita08.com. (
                            2022102501      ; Serial
                            604800         ; Refresh
                            86400         ; Retry
                            2419200         ; Expire
                            604800 )       ; Negative Cache TTL
    ;
    @               IN      NS      wise.ita08.com.
    @               IN      A       192.213.2.3 ;IP Eden
    www             IN      CNAME   wise.ita08.com.
    eden            IN      A       192.213.2.3 ;IP Eden
    www.eden        IN      CNAME   eden.wise.ita08.com.
    ns1             IN      A       192.213.2.2 ;IP Berlint
    operation       IN      NS      ns1
    www.operation   IN      CNAME   operation.wise.ita08.com
    @               IN      AAAA    ::1
   ```

    ```
    $TTL    604800
    @       IN      SOA     wise.ita08.com. root.wise.ita08.com. (
                            2022102501              ; Serial
                            604800         ; Refresh
                            86400         ; Retry
                            2419200         ; Expire
                            604800 )       ; Negative Cache TTL
    ;
    2.213.192.in-addr.arpa.  IN      NS      wise.ita08.com.
    3                        IN      PTR     wise.ita08.com.
    ```

#### Eden
1. Install wget untuk mendownload file dari google drive dan unzip untuk meng-extract
    ```
    apt-get install wget -y
    apt-get install unzip -y
    ```

2. Download file wise.zip menggunakan command `wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1S0XhL9ViYN7TyCj2W66BNEXQD2AAAw2e' -O wise.zip`

3. Unzip file yang sudah di download di /root dengan command `unzip wise.zip`

4. Copy file wise yang ada di root ke /var/www dengan command `cp -r /root/wise /var/www/wise.ita08.com`

5.  Copy file config default menjadi file config wise.ita08.com.conf dengan command `cp 000-default.conf wise.ita08.com.conf`

6. Ubah DocumentRoot wise.ita08.com.conf dan tambahkan juga ServerName beserta ServerAlias
   ```
   <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.ita08.com
        ServerName wise.ita08.com
        ServerAlias www.wise.ita08.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
   ```

7. Enable config dengan command `a2ensite wise.ita08.com` dan jangan lupa untuk restart `service apache2 restart`

### Testing
- Hasil testing menggunakan command `ping wise.ita08.com`
![testing-8a](img/soal_8/8a.png)
- Hasil testing menggunakan command `lynx wise.ita08.com`
![testing-8b](img/soal_8/8b.png)
![testing-8c](img/soal_8/8c.png)

## Soal 9
Setelah itu, Loid juga membutuhkan agar url www.wise.yyy.com/index.php/home dapat menjadi menjadi www.wise.yyy.com/home

### Penyelesaian
#### Eden
1. Tambah config pada `/etc/apache2/sites-available/wise.ita08.com.conf`
   ```
   <Directory /var/www/wise.ita08.com>
      Options +FollowSymLinks -Multiviews
      AllowOverride All
    </Directory>
    ```
    -  `AllowOverride All` ditambahkan agar konfigurasi .htaccess dapat berjalan.
    - `+FollowSymLinks` ditambahkan agar konfigurasi mod_rewrite dapat berjalan.
    - `-Multiviews` ditambahkan agar konfigurasi mod_negotiation tidak dapat berjalan mod_negotiation bisa 'rewrite' requests sehingga menimpa dan mengganggu mod_rewrite.

2. Aktifkan modul rewrite dengan command `a2enmod rewrite`

3. Tambahkan rewrite rule pada `/var/www/wise.ita08.com/.htaccess`
    ```
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule (.*) /index.php/$1 [L]
    ```
    - `RewriteEngine On` merupakan flag bahwa menggunakan module rewrite
    - `RewriteCond %{REQUEST_FILENAME} !-f` dan `RewriteCond %{REQUEST_FILENAME} !-d` sebagai aturan tidak akan jalan ketika yang diakses adalah directory (d) dan file (f)
    - `RewriteRule (.*) /index.php/$1 [L]` merupakan parameter input yang akan dicari oleh webserver

4. Jangan lupa untuk melakukan restart apache `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx wise.ita08.com/home`
![](img/soal_9/9a.png)
![](img/soal_9/9b.png)

## Soal 10
Setelah itu, pada subdomain www.eden.wise.yyy.com, Loid membutuhkan penyimpanan aset yang memiliki DocumentRoot pada /var/www/eden.wise.yyy.com

### Penyelesaian
#### Eden
1. Copy konfigurasi wise.ita08.com dengan perintah `cp /etc/apache2/sites-available/wise.ita08.com.conf /etc/apache2/sites-available/eden.wise.ita08.com.conf`

2. Copy file wise.eden yang ada di root ke /var/www dengan command `cp -r /root/eden.wise /var/www/eden.wise.ita08.com`

3. Ubah config dari eden.wise.ita08.com sebagai berikut
    ```
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/eden.wise.ita08.com
            ServerName eden.wise.ita08.com
            ServerAlias www.eden.wise.ita08.com

            <Directory /var/www/eden.wise.ita08.com>
                    Options +FollowSymLinks -Multiviews
                        AllowOverride All
            </Directory>

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```

4. Enable config eden.wise.ita08.com dan restart apache
    ```
    a2ensite eden.wise.ita08.com 
    service apache2 restart
    ```

### Testing
- Hasil testing menggunakan command `ping eden.wise.ita08.com`
![](img/soal_10/10a.png)

- Hasil testing menggunakan command `lynx eden.wise.ita08.com`
![](img/soal_10/10b.png)
![](img/soal_10/10c.png)

## Soal 11
Akan tetapi, pada folder /public, Loid ingin hanya dapat melakukan directory listing saja

### Penyelesaian
#### Eden
1. Tambah konfigurasi `+Indexes` pada `/etc/apache2/sites-available/eden.wise.ita08.com.conf` sebagai berikut
    ```
    <Directory /var/www/eden.wise.ita08.com>
                Options +Indexes  +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
    ```

2. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx eden.wise.ita08.com/public`
![](img/soal_11/11a.png)
![](img/soal_11/11b.png)

## Soal 12
Tidak hanya itu, Loid juga ingin menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache

### Penyelesaian
#### Eden
1. Tambahkan config .htaccess pada `/var/www/eden.wise.ita08.com/.htaccess` sebagai berikut
```
ErrorDocument 404 /error/404.html
```
2. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx eden.wise.ita08.com/asdf`
![](img/soal_12/12a.png)
![](img/soal_12/12b.png)

## Soal 13
Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js

### Penyelesaian
#### Eden
1. Tambahkan config berikut pada `/etc/apache2/sites-available/eden.wise.ita08.com.conf`
    ```
    <Directory /var/www/eden.wise.ita08.com>
                Options +Indexes  +FollowSymLinks -Multiviews
                AllowOverride All
    </Directory>

    Alias "/js" "/var/www/eden.wise.ita08.com/public/js"
    ```

2. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx eden.wise.ita08.com/js`
![](img/soal_13/13a.png)
![](img/soal_13/13b.png)

## Soal 14
Loid meminta agar www.strix.operation.wise.yyy.com hanya bisa diakses dengan port 15000 dan port 15500

### Penyelesaian
#### Eden
1. Copy file strix.operation yang ada di root ke /var/www dengan command `cp -r /root/eden.wise /var/www/eden.wise.ita08.com`

2. Copy config eden.wise.ita08.com ke strix.operation.wise.ita08.com dengan command `cp /etc/apache2/sites-available/eden.wise.ita08.com.conf /etc/apache2/sites-available/strix.operation.wise.ita08.com.conf`

3. Ubah konfigurasi dari `/etc/apache2/sites-available/strix.operation.wise.ita08.com.conf` sebagai berikut
    ```
    <VirtualHost *:15000>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita08.com
        ServerName strix.operation.wise.ita08.com
        ServerAlias www.strix.operation.wise.ita08.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>

    <VirtualHost *:15500>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/strix.operation.wise.ita08.com
            ServerName strix.operation.wise.ita08.com
            ServerAlias www.strix.operation.wise.ita08.com

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```

4. Enable config strix.operation.wise.ita08.com `a2ensite strix.operation.wise.ita08.com`

5. Masukkan port 1500 dan port 15500 ke dalam `/etc/apache2/ports.conf` sebagai berikut
    ```
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
    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    ```

6. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx strix.operation.wise.ita08.com`
![](img/soal_14/14a.png)

![](img/soal_14/14b.png)
>Port 15000

![](img/soal_14/14c.png)
>Port 15500

## Soal 15
dengan autentikasi username Twilight dan password opStrix dan file di /var/www/strix.operation.wise.yyy

### Penyelesaian
#### Eden
1. Tambahkan config untuk autentikasi pada `/etc/apache2/sites-available/strix.operation.wise.ita08.com.conf` sebagai berikut
    ```
    <VirtualHost *:15000>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita08.com
        ServerName strix.operation.wise.ita08.com
        ServerAlias www.strix.operation.wise.ita08.com

        <Directory "/var/www/strix.operation.wise.ita08.com">
                AuthType Basic
                AuthName "Restricted Content"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    <VirtualHost *:15500>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/strix.operation.wise.ita08.com
            ServerName strix.operation.wise.ita08.com
            ServerAlias www.strix.operation.wise.ita08.com

            <Directory "/var/www/strix.operation.wise.ita08.com">
                    AuthType Basic
                    AuthName "Restricted Content"
                    AuthUserFile /etc/apache2/.htpasswd
                    Require valid-user
            </Directory>

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```

2. Buat kredensial untuk mengakses website dengan command `htpasswd -c /etc/apache2/.htpasswd Twilight`
    - `-c` digunakan untuk create file passwd
    ![](img/soal_15/15a.png)

3. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx strix.operation.wise.ita08.com`
![](img/soal_15/15b.png)
![](img/soal_15/15c.png)
![](img/soal_15/15d.png)

## Soal 16
dan setiap kali mengakses IP Eden akan dialihkan secara otomatis ke www.wise.yyy.com

### Penyelesaian
#### Eden
1. Tambahkan config `Redirect 301 / http://www.wise.ita08.com` pada `/etc/apache2/sites-available/000-default.conf` sebagai berikut
    ```
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html
            Redirect 301 / http://www.wise.ita08.com


            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>

    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    ```

2. Restart server apache dengan command `service apache2 restart`

### Testing
- Hasil testing menggunakan command `lynx 192.213.2.3`
![](img/soal_16/16a.png)

## Soal 17
Karena website www.eden.wise.yyy.com semakin banyak pengunjung dan banyak modifikasi sehingga banyak gambar-gambar yang random, maka Loid ingin mengubah request gambar yang memiliki substring “eden” akan diarahkan menuju eden.png. Bantulah Agent Twilight dan Organisasi WISE menjaga perdamaian!

### Penyelesaian
#### Eden
1. Tambahkan rewrite rule pada .htacces yang terletak pada `/var/www/eden.wise.ita08.com/.htaccess` sebagai berikut
    ```
    ErrorDocument 404 /error/404.html
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^public/images/.*eden.*$ public/images/eden.png [NC,L]
    ```
    - `NC` flag nocase digunakan agar RewriteRule tidak case-sensitive
    - `L` flag last digunakan agar mod_rewrite berhenti memproses rule set. Dengan demikan, jika rule yang ditetapkan sesuai, maka tidak ada rule lain yang akan diproses

## Kendala Pengerjaan
