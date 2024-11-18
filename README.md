# Dotfiles

## Installing

My default distro is debian 12 bookworm.

After a fresh install make sure there is a non-root account that can be used as main account. This is pretty hard to avoid.  Name the default account in the appropriately. If this is a dev system, I like to use my most common username so that I don't have to type the username when logging via ssh.  If this will host an applicatoin, the the username may just be 'app' or the name of the app.

Once everything is installed, it be that you need to use the root account to get things started.

After an install, ensuring that I had the network working in the install, I will put the system in place and ssh into the system to do this configuration.  It is also possible and easy to use the console or a full blown desktop enviornment to setup the box.

I will cheat and use my home router UI to discover the IP address of the new system, then ssh into the system using my non-root user.

### As root

* change to root user `su -`
* update all softwware `apt update && apt upgrade`
* install sudo `apt install sudo`
* add non-root user to the sudo group `vim /etc/group`
* install base tools `apt install vim git tmux zsh rcm curl wget`
* change shell for non-root user to zsh `chsh -s /usr/bin/zsh <username>`
* exit completely and ssh back in as non-root user.

### As non-root

* checkout the dotfiles `mkdir repos && cd repos && git clone https://github.com/glhewett/dotfiles-public`
* checkout private (personal) dotfiles `cd repos && git clone git@github.com:glhewett/dotfiles-private`
* install dotfiles
  * without private `RCRC=repos/dotfiles-public/rcrc rcup`
  * with private `RCRC=repos/dotfiles-private/rcrc rcup`
* logout and login again
  * it should be obvious that your shell was changed.  Check it anywyas `echo $SHELL`
  * do a long listing in your home directory, and you will see a lot of symbolic links into the dotfiles folder `ls -la`

### Install firewall

```bash
# install the firewall software
sudo apt install ufw

# allow ssh port 22
sudo ufw allow ssh

# allow port 8001 (my app)
sudo ufw allow 8001/tcp

# turn on the firewall
sudo ufw enable
```

### Configure SSH

Before configuring ssh, ensure that you are able to login using an ssh key.  This will require the creation of a file containing one or more public keys in the `~/.ssh/authorized_keys` file.  This file should be owned by the user and have the permissions `600`.

Test the key again.

* edit /etc/ssh/ssh_config `sudo vim /etc/ssh/ssh_config`
* Update the following settings:

```
PasswordAuthentication no
PermitRootLogin no`
```

* restart the ssh service `sudo systemctl restart sshd`

### Install Docker

* follow the directions at this url: https://docs.docker.com/engine/install/debian/

```sh
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
do
  sudo apt-get remove $pkg
done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

* add user to docker group `sudo usermod -aG docker $USER`
* log out and log back in

