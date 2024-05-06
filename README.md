# Features

This is an installer for [Alpine linux](https://www.alpinelinux.org/) with ZFS as root filesystem, and [ZFSBootMenu](https://docs.zfsbootmenu.org/) to boot into different environments.

Since installing Alpine with ZFS and ZfsBootmenu needs a whole tutorial with many steps, we've created this easy installer.

* Fastest and easiest way to install Alpine on ZFS 
* Uses the excellent [ZFS](https://openzfs.org/wiki/Main_Page) filesystem.  
* [ZFSBootMenu](https://docs.zfsbootmenu.org/) as bootloader, which allows you to rollback in case of failed upgrades.
* After installing it can boot both in BIOS mode and UEFI mode. 
* Perfect for running docker.
* Also easy to install at VPS providers that do not provide an Alpine installer.
* Install time is about 1 minute.

![image](https://github.com/psy0rz/alpinebox/assets/1179017/fc9fb0a9-d88f-4943-814f-9f39d1be11a0)


## Why Alpine Linux?

Alpine is one of the best and cleanest Linux distros out there, for running Docker and various other stuff. Packages like the Linux kernel, ZFS support and Docker are very up to date but also very stable. 

Its super small, fast and simple. Its not the most versatile distribution, but what it does, it does very well.

Also upgrading to newer releases is quick and painless, in contrast with other distro's. And since we use snapshots before upgrading, its easy to roll back should there be a problem.

For this reason all our boxes run Alpine and just auto-upgrade and reboot every week without problems.

# Installing 

Installation by just writing the official image to the disk is the easiest way:

* Boot any Linux distro via CD, USB. Or use a rescue-boot if you use some kind of VPS hosting provider. (example image below)
* Download the imager:
```
# wget https://boot.datux.nl/image
```
NOTE: This is just a redirect to https://raw.githubusercontent.com/psy0rz/alpinebox/master/install/installimage.sh

* Start the imager and specify your harddisk:
```
# sh image /dev/sda
```
This should download and reboot, and you're basically done :)

## Example installation on a Hetzner VPS:

![image](https://github.com/psy0rz/alpinebox/assets/1179017/b3553522-8305-4cc2-86c2-6b86fd8ff61e)

## Login

There is no root-password for console logins. However, for ssh you will need to add your keys. 
For an example of this see `/root/alpinebox/add-datux-keys`, which we ourself always use.

## Growing the disk

Since it's an image, you will need to grow the partition and zfs disk:
![image](https://github.com/psy0rz/alpinebox/assets/1179017/7aced4e6-bc15-4be0-803c-69f5717f04af)

Just run `grow-disks` script in /root/alpinebox, and it should be handled automaticly without a reboot even.

**Do this as soon as possible, since its a somewhat risky operation** 


## Adding a disk

To add a disk to the zpool as a mirror, just run the `add-disk` script in /root/alpinebox 

This will also make sure that the disk has the correction partitioning, MBR/UEFI and ZfsBootmenu stuff. 
So that if the first disk completely fails, you can still boot from this one.

Make sure you remove any non-ONLINE disks from the pool first.

## Backups

To make backups via ZFS replication, check out my other project: https://pypi.org/project/zfs-autobackup/

## Safe updates

Now everytime you need to do a bunch of Alpine upgrade, just run something like: `zfs snapshot rpool/ROOT@upgrades1`

If the upgrade fails you can rollback via the ZfsBootmenu.

# Installing via official Alpine installer

If you dont like the imaging method above, you can also use the official Alpine ISO and our install scripts:

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


# Install docker with zfs-volume support

(TODO: provide our scripts)

# More info

Based on this excellent tutorial: https://docs.zfsbootmenu.org/en/v2.3.x/guides/alpine/uefi.html

