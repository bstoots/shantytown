#!/bin/sh
# TODO - This should be added to guest_ansible plugin to provide support for FreeBSD
sudo pkg install -y gcc bash git python py27-pycrypto
fetch http://peak.telecommunity.com/dist/ez_setup.py
sudo python ez_setup.py && rm -f ez_setup.py
sudo easy_install pip
sudo pip install setuptools --no-use-wheel --upgrade
sudo pip install paramiko pyyaml jinja2 markupsafe
sudo pip install ansible==1.9.4
# Generate an inventory file on the fly
echo "freebsd-development-vm ansible_ssh_host=127.0.0.1 ansible_ssh_port=22223 ansible_python_interpreter=/usr/local/bin/python" > /tmp/ansible_hosts
# Run that sweet sweet Ansible
fetch http://is.dev.pitbpa0.priv.intermedix.com/~brian.stoots/shantytown/ansible.cfg -o /home/vagrant/.ansible.cfg
echo "Running Ansible as $USER: "
ansible-playbook /vagrant/master.yml --inventory-file=/tmp/ansible_hosts --connection=local -e $1
