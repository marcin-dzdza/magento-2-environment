Environment for projects in Magento 2

#1. Requirements

- Git
- Vagrant 2.0.1
- Ansible 2.4.2.0
- nfs-common
- access to repo.magento.com (private and public key)

This instruction assumes you are using Ubuntu.

#2. Installation

##1. Clone Dev Environment git repository and checkout branch master

```
git clone https://github.com/marcin-dzdza/magento-2-environment.git --branch master
```

Root directory of this repo will be referred to as {env_root_dir}

##2. Copy your ssh keys to ansible tmp dir

Vagrant may need your ssh private key to clone your private repositories.
For this purpose, you need to copy your keys to ansible tmp dir

```
cp -t {env_root_dir}/ansible/tmp ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
```

If you haven't done it already, you may generate your keys by running:
```
ssh-keygen -t rsa
```

##3. Add hostname to /etc/hosts

Assuming you want to use magento.local hostname:

```
echo '192.168.33.40 magento.local' | sudo tee -a /etc/hosts
echo '192.168.33.40 myadmin.magento.local' | sudo tee -a /etc/hosts
```

##4. Activate ansible config file

```
cp {env_root_dir}/ansible/group_vars/all.default {env_root_dir}/ansible/group_vars/all
```

##5. Configure ansible to fit your needs

Edit variables in {env_root_dir}/ansible/group_vars/all. 

a) You have to provide credentials to repo.magento.com, otherwise installation will fail:
- repo_magento_username
- repo_magento_password

b) app_hostname has to match the host in /etc/hosts

c) app_repo has to point to the repository you want to install in your environmant
It has to be similar to the default https://github.com/marcin-dzdza/magento-2-project
Ansible assumes:

i) the repository will have the following structure
- /                       (root dir with files not specific to magento)
- /magento                (subdirectory where magento will be installed)
- /magento/composer.json  (list of dependencies)

ii) this repo will not actually include magento or magento modules, only composer.json with magento as dependency

iii) the composer.json requires "magento/product-community-edition": "2.1.8" (other versions may not work)

##6. Run vagrant up

```
cd {env_root_dir}/vagrant-dev
vagrant up
```

If ansible fails, you may re-run it by:

```
vagrant provision
```

If ansible fails, it is possible that nginx and php-fpm will never be restarted, you may have to do it manually.

#3. Additional info

##1. To mount project directory:

```
mkdir {mount_dir}
sudo mount -t nfs -o proto=tcp,port=2049 192.168.33.40:/var/www/project {mount_dir}
```

After mounting the directory, you can open it locally in PhpStorm.

##2. Xdebug

Guest machine has xdebug installed and php.ini modified.
You need to configure PhpStorm and browser.

##3. PhpMyAdmin

You can browse database on myadmin.magento.local. User: root, password specified in ansible group_vars/all

##4. Connect to database by ssh

Data to configure connection to mysql in PhpStorm, Mysqlworkbench or other applications.

General
Host: localhost
Database: {{ app_db_name }} (default: magento)
User: {{ app_db_user }} (default: magento)
Password: {{ app_db_password }} (default: admin123)

SSH/SSL
use SSH tunnel
Proxy host: 192.168.33.40
Proxy user: vagrant
Auth type: Key pair
Private key file: {env_root_dir}/vagrant-dev/.vagrant/machines/default/virtualbox/private_key

##5. Sample data

If you want to install sample data, run:

```
cd {env_root_dir}/vagrant-dev
vagrant ssh
(as user vagrant) sh /ansible/sampleData.sh
```

##6. Magento Dev Tools

Follow this instruction to configure PhpStorm and browser:
https://github.com/magespecialist/mage-chrome-toolbar#installing-on-magento-2

Everything related to Magento itself can be done by:
```
cd {env_root_dir}/vagrant-dev
vagrant ssh
(as user vagrant) sh /ansible/devTools.sh
```

##6. Working with the environment

Create project repository similar to https://github.com/marcin-dzdza/magento-2-environment.git

Select modules and themes that you want to install and add them to composer.json

If you need to create your own module, you can:
a) create new repo for it and require it in composer.json
b) create it in app/code

Your private modules from GitHub exist in vendor as separate git repositories.
If you enter their directories, you can git commit, pull and push.
If you want to use PhpStorm features with them, you have to open each module as separate PhpStorm project

If there are changes in composer.json, local or external modules, and you want to adopt them, run
```
cd {env_root_dir}/vagrant-dev
vagrant ssh
(as user vagrant) sh /ansible/update.sh
```


