sudo git clone -b 35.x https://github.com/enterprisemediawiki/meza.git /opt/meza
read -p "Press any key to continue"
sudo bash /opt/meza/src/scripts/getmeza.sh
read -p "Press any key to continue"
sudo meza deploy monolith