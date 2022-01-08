# Inteface

echo "              +---------------------------------------------+"
echo "              |        Script For Ghost Installation        |"
echo "              |        Maintained by : Hostarts             |"
echo "              |        For production use only              |"
echo "              +---------------------------------------------+"
echo ""
echo "[!] CAUTION : This script will create a admin user 'u_ghost' with the passwd you provide"
echo "               plus it will add Nginx to the UFW firewall system as full allow, if you"
echo "               are not using UFW please allow Nginx in default Firewall system!"
echo ""
echo "[!] NOTE    : This is a beta version script, Please ensure the Installation of MySQL and other prerequisites"
echo "               in accordance with the guide available on : https://ghost.org/docs/install/ubuntu/"
echo ""
echo "[!] NOTE    : Please conform to the the company's security policy before running the script!"
echo ""
read -p "[+] Press enter to Continue..."
echo -e "[+] Enter your website name : \c" $site
read site
echo -e "[+] Enter password for ghost user 'u_ghost' : \c" $pass
read -s pass
echo ""
echo -e "[+] Enter password again for verification   : \c" $pass1
read -s pass1
echo ""

if [[ $pass != $pass1 ]]
then
	echo "[x] PASSWORDS DONT MATCH, EXITING..."
	exit 1
fi

# Installing prerequisites

apt-get update -y
apt-get upgrade -y
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt-get install -y nodejs npm
apt-get install -y nginx
npm install -g npm@8.3.0
npm install ghost-cli@latest -g

echo ""
echo "[+] Prerequisites Installed : "
echo "    [1] UFW"
echo "    [2] NGINX"
echo "    [3] NODEJS"
echo "    [4] GHOST CLI"
echo ""

# adding nginx to UFW

ufw allow 'Nginx Full'

# adding user

chk_user=$(cat /etc/passwd | grep "u_ghost" | grep -c '^')
if [[ $chk_user == "" || $chk_user == "0" ]]
then
	useradd -m --shell /bin/bash u_ghost -p $pass
	usermod -aG sudo u_ghost
else
	echo "[!] User u_ghost Already present! skipping..."
fi

# Installing ghost

mkdir -p /var/www/$site
chown u_ghost:u_ghost /var/www/$site
chmod 775 -R /var/www/$site
cd /var/www/$site
su u_ghost -c "ghost install"
