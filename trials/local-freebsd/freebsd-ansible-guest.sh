#!/usr/local/bin/bash
# Sick of being trolled by stupid scripts designed for Linux 
sudo ln -s /usr/local/bin/bash /bin/bash
# TODO - This should be added to guest_ansible plugin to provide support for FreeBSD
sudo pkg install -y gcc git python
fetch http://peak.telecommunity.com/dist/ez_setup.py
sudo python ez_setup.py && rm -f ez_setup.py
sudo easy_install pip
sudo pip install setuptools --no-use-wheel --upgrade
sudo pip install paramiko pyyaml jinja2 markupsafe
sudo pip install ansible
