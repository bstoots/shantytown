# development-vm

## Goals
* Provide a base-line VM definition for development work.  Especially useful for 
  Windows-based developers since tools like Ansible are unavailable on that platform.

## Prerequisites 
* [Git](https://git-scm.com/)
* Powershell
* [Vagrant](https://www.vagrantup.com)
* [vagrant-guest_ansible Provisioner](https://github.com/vovimayhem/vagrant-guest_ansible)

## Setup
* First off decide where you will store your development VM checkout and configuration. 
  I usually create a new directory in a dedicated VM directory named after the new VM
  I am about to create.
  ```powershell
  E:\vm> 
  New-Item -ItemType Directory -Name SOMEVM-VM-NAME
  cd .\SOMEVM-VM-NAME\
  ```

* Clone the project.  I recommend using a sparse checkout to avoid getting 
  extraneous project files.
  ```powershell
  E:\vm\SOMEVM-VM-NAME>
  git init
  git remote add -f origin git@github.com:bstoots/shantytown.git
  # Or use this if you don't have a Github account:
  # git remote add -f origin git://github.com/bstoots/shantytown.git
  git config core.sparsecheckout true
  Write-Output "development-vm"| Out-File -Encoding ascii .\.git\info\sparse-checkout
  git pull origin master
  cd .\development-vm\
  ```

* Before you can actually bring up the VM you will need to define a couple of configuration
  files.  These files are vagrant_config.yml and ansible_config.yml.  Their specific
  formats and values are defined below but make sure you have these defined before continuing.
  ```powershell
  E:\vm\SOMEVM-VM-NAME\development-vm> ls
  ...
  Mode                LastWriteTime     Length Name
  ----                -------------     ------ ----
  -a---         9/22/2015     10:20       1937 ansible_config.yml
  ...
  -a---         9/22/2015     10:21        451 vagrant_config.yml
  ...
  ```

* Once your configs are defined all you have to do is bring up the VM
  ```powershell
  E:\vm\SOMEVM-VM-NAME\development-vm>
  vagrant up
  ```

* Assuming all the provisioning went as planned you should now be good to go!  If 
  you encounter configuration related errors during provisioning you can fix them and 
  try again as follows:
  ```powershell
  E:\vm\SOMEVM-VM-NAME\development-vm>
  vagrant provision
  ```

## Troubleshooting

## Config
vagrant_config.yml and ansible_config.yml are YAML files containing hashes that define
various config options for vagrant and ansible provisioning.

### vagrant_config.yml
```yaml
---
config:
  hostname: 
  vmname: 
  sshport: 
  publicmac: 
```

* **hostname**: _(Required)_ Value of the config.vm.hostname option.  Any valid hostname.
* **vmname**: _(Required)_ Value of the config.vm.provider.name option.  Any valid VM name.
* **sshport**: _(Optional)_ Overrides the default SSH port forwarding.  Useful if you want
  bind this VM to a specific port.  Must be a valid port number or omitted.
* **publicmac**: _(Optional)_ Allows explicitly setting MAC address on public adapter.
  This was added to support networking rules on persistent machines.  Must be a valid MAC
  address, auto, or omitted.

### ansible_config.yml
```yaml
---
config:
  # See Roles for valid config options
```

## Roles

### apt-packages
Installs aptitude packages from upstream repositories
#### Config
```yaml
aptpackages:
  - packagename
  - foo
```
aptpackages list takes any number of valid aptitude package names

### composer
Installs composer binary
#### Config
None

### composer-global-packages
Installs composer packages globally
#### Config
```yaml
composerglobalpackages:
  binary: "vendor/package:version"
  dbsteward: "nkiraly/dbsteward:dev-master"
```
composerglobalpackages hash takes any number of valid composer packages.  Keys are
target binary name.  Values are vendor/package:version references needed by composer.

### deb-packages
Downloads and installs debian packages from arbitrary URLs
#### Config
```yaml
debpackages:
  somedeb.deb: http://location.of/somedeb.deb
```
debpackages hash takes any number of deb targets.  Keys are name of the deb to be 
created on the local machine.  Values are URLs of debs to download.

### imx-java-dev
Installs Java development tools and configures use of Nexus
#### Config
```yaml
javahome: "/path/to/jvm/java-1.7.0-openjdk-amd64"
nexuscert: "http://location.of/cert.cer"
nexussettings: "http://location.of/settings.xml"
nexusstorepass: somepass
```

* **javahome**: _(Required)_ Location of Java on the guest machine
* **nexuscert**: _(Required)_ URL download location of Nexus certificate
* **nexusstorepass**: _(Required)_ Password of the cacerts keystore
* **nexussettings**: _(Required)_ URL download location of Nexus settings for Maven

### network
Configures network adapters according to role template
#### Config
None

### nfs-client
Configures and mounts NFS share
#### Config
```yaml
nfsmount: /path/to/nfs
nfsserver: location.of.nfs
nfsexport: /path/to/export
```

* **nfsmount**: _(Required)_ Local mount point for this NFS share on the guest machine. 
  Directory will be created if it does not exist
* **nfsserver**: _(Required)_ Network address of the NFS server
* **nfsexport**: _(Required)_ Export path on the NFS server

### timezone
Sets the local timezone
#### Config
```yaml
timezone: America/New_York
```

This may be any valid Ubuntu timezone as specified here: [Ubuntu Timezones](http%3A%2F%2Fmanpages.ubuntu.com%2Fmanpages%2Fsaucy%2Fman3%2FDateTime%3A%3ATimeZone%3A%3ACatalog.3pm.html)

### user
Configures user and group
#### Config
```yaml
username: some.user
usergroup: some.group
uid: 10000
gid: 10000
```

* **username**: _(Required)_ Any valid username
* **usergroup**: _(Optional)_ Defaults to same as username
* **uid**: _(Optional)_ Any valid user id
* **gid**: _(Optional)_ Any valid group id

