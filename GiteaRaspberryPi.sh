#Raspbian OS un lite versiyonu olan image dosyasını yüklüyoruz. 
#Sadece konsol üzerinden erişeceğimiz için desktop versiyonunu tercih etmedim.

#Aşağıdaki komutlar ile RPI cihazın güncellemelerini yükleyin.
sudo apt-get update && sudo apt-get upgrade

#Aşağıdaki komut ile ayarlara ulaşıp default şifrenizi değiştirip SSH portunuzu aktif ediniz.
#(wlan bağlantı kullananlar Wifi ayarlarını buradan yapabilirler.)
sudo raspi-config 

#Şimdi Docker kuruyoruz.
curl -sSL https://get.docker.com | sh

#pi kullanıcısını docker a tanıtıyoruz.
sudo usermod -aG docker pi

#şimdi ileride kuracağımız stak için docker-compose kuruyoruz.

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

sudo pip3 install docker-compose

#docker kurulduktan sonra docker image lerininin web üzerinden güncellenmesi ve bakımı ve performansı gözlemlemek için portainer kuruyoruz.(isteğe bağlıdır)
sudo docker pull portainer/portainer-ce:linux-arm
sudo docker run --restart always -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:linux-arm

#Time zone ayarlıyoruz.
sudo dpkg-reconfigure tzdata

#yeni bir git kullanıcı tanımlıyoruz.
sudo adduser --disabled-login --gecos 'Gitea' git

#Gitea için oluştutulan git kullanıcısını docker a tanıtıyoruz.
sudo usermod -aG docker git

#oluşturduğumuz git kullanıcısı kontrol ediyoruz 2. satırdaki cevabı almamız gerekiyor.
sudo -u git id
=>  uid=1001(git) gid=1001(git) groups=1001(git) 

#Şimdi USB disk için bir dosya adresi oluşturup izinlerini alıyoruz.
sudo mkdir /mnt/git
sudo chown -R git:git /mnt/git
sudo chmod -R 775 /mnt/git

#Aşağıdaki kodu çalıştırıp mount edilecek USB diskin UUID sini kopyalıyoruz.
sudo blkid

#Şimdi kopyaladığımız UUID verisi ile aşağıdaki satırı güncelliyoruz ve fstab dosyasının altına ekliyoruz.
#UUID=00F60E97F60E8D5A     /mnt/git     ntfs-3g      uid=1001,gid=1001,umask=002 0 0
sudo nano /etc/fstab

#USB cihazı mount ediyoruz.
sudo mount -a

#şimdi USB cihazın mount listesinde olup olmadığını kontrol ediyoruz.
sudo mount -fav

#gelen cevap bu olmalı;
#/proc                         : already mounted
#/boot                         : already mounted
#/                             : ignored
#/mnt/git                      : successfully mounted <<<<< !!!!

#Gitea doker compose için açmış olduğumuz git kullanıcına atlıyoruz.
sudo su - git 

#bir dosya oluşturuyor ve içine giriyoruz.
mkdir gitea
cd gitea

#aşağıdaki kodu çalıştırınca karşımıza nano text editör yeni bir sayfa getirecek. buraya repo içindeki "docker-compose.yml" isimli dosyanın tamamını kopyalayıp yapıştırıyoruz.
nano docker-compose.yml
# kaydetmek için ctrl + O tuşluyoruz devamında enter daha sonra dosyadan çıkmak için ctrl + X tuşluyoruz.

#Son olarak docker stack dosyamızı çalıştırıyoruz. 
docker-compose up -d

#Git user den çıkmak için "exit" yazabilirsiniz.

#kurulum tamamlandıktan sonra http://<local_ipadres>:3000 adresinden gitea kurulum sayfasına girebilirsiniz.

#Şimdi çay molası :)





