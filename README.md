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
