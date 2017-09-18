# run this code into the instance inpho-base

# 1. elementi di base per lavorare con il progetto
sudo su

# 2.
apt-get update; apt-get install git-core -y

# 3. scarica il progetto di lavoro
git clone https://github.com/favsto/intech-compute-balancing

# 4.
mv intech-compute-balancing /usr/local/intech; cd /usr/local/intech/init/; chmod +x setup.sh

# 5. lancia il setup e attendi che finisca
./setup.sh

# 6. esci dal superuser e dalla console
exit

exit