variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

resource "null_resource" "ssh_target" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && apt upgrade -y",
	   "sudo apt install apache2 apache2-utils -y",
		"sudo systemctl restart apache2",
		"sudo apt install mariadb-server mariadb-client -y",
		"sudo systemctl restart mariadb",
      "sudo apt install libapache2-mod-php php php-gd php-mbstring php-mysql php-curl php-xml php-cli php-intl php-zip unzip -y",      
      "wget https://github.com/PrestaShop/PrestaShop/releases/download/1.7.8.8/prestashop_1.7.8.8.zip",
      "sudo mkdir /tmp/prestashop",      
      "sudo unzip prestashop_1.7.8.8.zip -d /tmp/prestashop/",
      "sudo cp /tmp/prestashop/* /var/www/html/",
      "sudo unzip prestashop.zip -d /var/www/html/",	
      "sudo chown -R www-data:www-data /var/www/html/",
      "sudo chmod -R 775 /var/www/html/",
      "sudo mysql -e 'CREATE DATABASE prestashop_db;'",
      "sudo mysql -e 'CREATE USER shopuser@localhost IDENTIFIED BY \"eshop59\"';",
      "sudo mysql -e 'GRANT ALL PRIVILEGES ON prestashop_db.* TO shopuser@localhost;'",
      "sudo mysql -e 'FLUSH PRIVILEGES;'",
      "sudo mysql -e 'exit'"
      

    ]
  }
}

output "host" {
value = var.ssh_host
}
output "user" {
value = var.ssh_user
}
output "key" {
value = var.ssh_key
}

