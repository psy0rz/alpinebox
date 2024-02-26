# Features

This is an installer for [Alpine linux](https://www.alpinelinux.org/) with ZFS as root filesystem, and [ZFSBootMenu](https://docs.zfsbootmenu.org/) to boot into different environments.

Since installing Alpine with ZFS and ZfsBootmenu needs a whole tutorial with many steps, we've created this easy installer.

* Uses the excellent [ZFS](https://openzfs.org/wiki/Main_Page) filesystem.  
* [ZFSBootMenu](https://docs.zfsbootmenu.org/) as bootloader, which allows you to rollback in case of failed upgrades.
* After installing it can boot both in BIOS mode and UEFI mode. 
* Perfect for running docker.
* Also easy to install at VPS providers that do not provide an Alpine installer.

![image](https://github.com/psy0rz/alpinebox/assets/1179017/fc9fb0a9-d88f-4943-814f-9f39d1be11a0)


## Why Alpine Linux?

Alpine is one of the best and cleanest Linux distros out there, for running Docker. Packages like the Linux kernel, ZFS support and Docker are very up to date but also very stable. 

Its super small, fast and simple.

Also upgrading to newer releases is quick and painless, in contrast with other distro's. And since we use snapshots before upgrading, its easy to roll back should there be a problem.

For this reason all our boxes run Alpine and just auto-upgrade and reboot every week without problems.

# Installing 

Installation by just writing the official image to the disk is the easiest way.

* Boot any Linux distro via CD, USB. Or use a rescue-boot if you use some kind of VPS hosting provider. (example image below)
* Download the imager:
```
# wget https://boot.datux.nl/image
```
* Start the imager and specify your harddisk:
```
# sh image /dev/sda
```
This should download and reboot, and you're basically done :)

![image](https://github.com/psy0rz/alpinebox/assets/1179017/b3553522-8305-4cc2-86c2-6b86fd8ff61e)

## Login

There is no root-password for console logins. However, for ssh you will need to add your keys. 
For an example of this see `/root/alpinebox/add-datux-keys`, which we ourself always use.

## Growing the disk

Since it's an image, you will need to grow the partition and zfs disk.

Just run `grow-disks` script in /root/alpinebox, and it should be handled automaticly without a reboot even.

# Installing via official Alpine installer

If you dont like the imaging method, you can also use the official Alpine ISO and our install scripts:

## 1. Boot Alpine installer

Get and boot Alpine 3.19: https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-extended-3.19.1-x86_64.iso

Note: Should be the extended edition, since that one has ZFS support.

## 2. Configure network

Get you network configured with:
```
setup-interfaces -r
```

## 3. Run this quick installer

```
wget https://boot.datux.nl/install
sh install /dev/sda
```

This will partition/format/install and reboot.


# Creating you own image

Look in the devtools directory. With `createimage.sh` you can create your own image.
Run it from an Alpine ISO or installation. 
You might need to install some dependencies first if something fails.


# Adding or replacing a ZFS disk

(TODO: Will be very easy by calling a script as well, that does partitioning/formatting etc )

# Install docker with zfs-volume support

(TODO: provide our scripts)

# More info

Based on this excellent tutorial: https://docs.zfsbootmenu.org/en/v2.3.x/guides/alpine/uefi.html

