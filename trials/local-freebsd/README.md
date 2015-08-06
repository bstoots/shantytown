# Trial local-freebsd

## Goals
* Provision a FreeBSD VM with Ansible from a Windows host

## Prerequisites 
* [Vagrant WinNFSd](https://github.com/winnfsd/vagrant-winnfsd)
* [vagrant-guest_ansible Provisioner](https://github.com/vovimayhem/vagrant-guest_ansible)

## Notes
* Full NFS path on the host needs to be less than 88 characters
* winnfsd doesn't always stop when you stop / destroy a VM
