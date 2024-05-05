#!/usr/bin/env zsh
SSH_AUTH_SOCK_SYMLINK=$HOME/.ssh/ssh_auth_sock

# if $SSH_AUTH_SOCK exists and it a symlink, then read the path of the symlink
if [ -L "$SSH_AUTH_SOCK" ]
then
    # Read the value of the symlink
    SSH_AUTH_SOCK_ORIGINAL=$(readlink -f "$SSH_AUTH_SOCK_SYMLINK")
elif [ -e "$SSH_AUTH_SOCK" ]
then
    # SSH_AUTH_SOCK is not a symlink.  its the original
    SSH_AUTH_SOCK_ORIGINAL=$SSH_AUTH_SOCK
else
    echo "SSH_AUTH_SOCK is not found"
    exit 0
fi

# if the symlink does not exist or it changed, then write it.
if [ ! -e "$SSH_AUTH_SOCK_SYMLINK" ] || \
   [ "$SSH_AUTH_SOCK_ORIGINAL" != "$SSH_AUTH_SOCK" ]
then
    ln -vsf "$SSH_AUTH_SOCK_ORIGINAL" "$SSH_AUTH_SOCK_SYMLINK"
    export SSH_AUTH_SOCK=$SSH_AUTH_SOCK_SYMLINK
else
    readlink -f $SSH_AUTH_SOCK_SYMLINK
fi
