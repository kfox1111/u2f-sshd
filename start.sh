#!/bin/bash -e
mkdir -p /etc/sshstate/authorized_keys
if [ ! -f /etc/sshstate/ssh_host_ecdsa_key ]; then
  ssh-keygen -f /etc/sshstate/ssh_host_ecdsa_key -N '' -t ecdsa
fi
if [ -x /etc/sshstate/start.sh ]; then
  /etc/sshstate/start.sh
fi
echo To generate a key, exec in and run:
echo ssh-keygen -t ecdsa-sk
echo Add a user with:
echo "adduser <username>"
echo To enable auth:
echo "cat ~/.ssh/id_ecdsa_sk.pub > /etc/sshstate/authorized_keys/<username>"
echo Starting sshd.
/usr/local/sbin/sshd -D -E /var/log/ssh_debug
