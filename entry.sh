#!/bin/sh
set -x
SSH_HOST_KEY_DIR=/etc/ssh/ssh_host_keys

if [ ! -z "$ssh_port" ]; then
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
  echo "Port $ssh_port" >> /etc/ssh/sshd_config
fi

if [ ! -z "$ssh_pub_key" ]; then
	mkdir ~/.ssh
  echo "$ssh_pub_key" >> ~/.ssh/authorized_keys  
  /usr/sbin/sshd -D 
fi
