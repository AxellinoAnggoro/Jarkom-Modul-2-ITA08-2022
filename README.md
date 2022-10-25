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

4. Selanjutnya masukkan command `echo nameserver 192.168.122.1 > /etc/resolv.conf` ke node `WISE, SSS, Garden, Berlint, Eden` sehingga setiap node sekarang sudah dapat mengakses internet
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
1. Install bind9 pada DNS Master *WISE*
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

5. Pada client *Garden* dan *SSS* arahkan nameserver ke ip router *WISE* sebagai berikut:
   ```
    nameserver 192.213.3.2 #IP Wise
   ```

6. Ping domain `wise.ita08.com` menggunakan command `ping wise.ita08.com` pada client *Garden* dan *SSS*
    ![garden-ping](img/soal_2/ping-garden.png)
    ![sss-ping](img/soal_2/ping-sss.png)