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
  development_vm:
    # See Roles for valid config options
```

## Roles

### apt-packages
Installs aptitude packages from upstream repositories
#### Config
```yaml
apt_packages:
  - foo
  - bar
```
apt_packages is a list taking any number of aptitude package names

### composer
Installs composer binary
#### Config
None

### composer-global-packages
Installs composer packages globally
#### Config
```yaml
composer_global_packages:
  vendor/foo:
    bin: foo
    version: dev-master
  vendor/bar:
    bin: bar
    version: 1.*
```
composer_global_packages is a hash, keys are Composer vendor/package names.  Each vendor/package element is a hash defined as follows:

* **bin**: (_Required_) Name of the binary being created.
* **version**: (_Required_) Composer package version.

### deb-packages
Downloads and installs debian packages from arbitrary URLs
#### Config
```yaml
deb_packages:
  foo:
    url: http://location.of/foo.deb
    dest: /tmp/foo.deb
  bar:
    url: http://location.of/bar.deb
    dest: ~/bar.dev
```
deb_packages is a hash, keys are arbitrary identifiers.  Each deb identifier element is a hash defined as follows:

* **url**: (_Required_) URL of the Debian package file.
* **dest**: (_Required_) Download destination.

### groups
Adds additional groups
#### Config
```yaml
groups:
  groupname: 123
```
groups is a hash, keys are group names, values are optional GIDs.

### java-dev
Configures system for Java development
#### Config
```yaml
java_dev:
  java: openjdk
  java_home: /path/to/openjdk
```
java_dev is a hash defined as follows:

* **java**: (_Required_) Aptitude package name of the Java JDK to be installed
* **java_home**: (_Required_) Path to the JDK for setting JAVA_HOME env variable

### java-dev-maven
Configures system for Java development using Maven
#### Config
```yaml
java_dev_maven:
  maven: maven
  settings: http://location.of/settings.xml
```
java_dev_maven is a hash defined as follows:

* **maven**: (_Required_) Aptitude package name of Maven 
* **settings**: (_Optional_) URL download location of Maven settings

### java-dev-nexus
Configures system for Java development using Nexus.  Adds certificate too cacerts trust store, replacing existing certificate aliases when found.
#### Config
```yaml
java_dev_nexus:
  certificate: http://location.of/nexus.cer
  alias: nexus
  storepass: changeit
```
java_dev_nexus is a hash defined as follows:

* **certificate**: (_Required_) URL download location of Nexus server certificate
* **alias**: (_Required_) Certificate alias to be added to cacerts trust store
* **storepass**: (_Optional_) Keystore password for cacerts trust store

### network
Configures network adapters according to role template
#### Config
None

### nfs-client
Configures and mounts NFS shares.  Creates mount points if needed.
#### Config
```yaml
nfs_client:
  /path/to/mount:
    server: location.of.nfs.server
    export: /path/to/export
    options: rw
```

nfs_client is a hash, keys are paths to mount points on the guest.  Each mount point element is a hash defined as follows:

* **server**: _(Required)_ URL or IP address to the NFS server
* **export**: _(Required)_ Path to the NFS export on the remote server
* **options**: _(Optional)_ NFS options to be passed to mount / stored in fstab

### timezone
Sets the local timezone
#### Config
```yaml
timezone: 
  name: America/New_York
```

timezone is a hash, keys are defined as follows:

* **name**: (_Required_) This may be any valid tz database identifier as defined by IANA: [IANA Timezones](http://www.iana.org/time-zones).

### user
Configures user and group
#### Config
```yaml
user:
  username: foo
  usergroup: foo
  groups: bar,baz
  uid: 10000
  gid: 10000
```

user is a hash, keys are defined as follows:

* **username**: _(Required)_ Any valid username
* **usergroup**: _(Optional)_ Defaults to same as username
* **groups**: _(Optional)_ Additional groups for this user
* **uid**: _(Optional)_ Any valid user id
* **gid**: _(Optional)_ Any valid group id

