![logo](./logo/alpinebox-logo.svg)

**Climb high, roll back safely.**

This is an installer for [Alpine Linux](https://www.alpinelinux.org/) with ZFS as root filesystem, and [ZFSBootMenu](https://docs.zfsbootmenu.org/) to boot into different environments.

Since installing Alpine with ZFS and ZFSBootMenu needs a whole tutorial with many steps, we've created this easy installer.

* Fastest and easiest way to install Alpine on ZFS.
* Uses the excellent [ZFS](https://openzfs.org/wiki/Main_Page) filesystem.
* [ZFSBootMenu](https://docs.zfsbootmenu.org/) as bootloader, which allows you to roll back in case of failed upgrades.
* After installing it can boot in both BIOS mode and UEFI mode.
* Optional [automatic updates](#automatic-updates): snapshot, upgrade, and a fast kexec "quick reboot". The system rolls back automatically if the upgrade fails.
* Optional "batteries included" hosting server with [Hostbox](https://github.com/psy0rz/portainer-templates): one script (`./install-portainer-stack`) gives you a complete, ready-to-use setup to host many websites and web applications on one server:
  * [Portainer](https://www.portainer.io/) web GUI with ready-made app templates (WordPress, Magento, Nextcloud and more).
  * [Traefik](https://traefik.io/) reverse proxy with automatic SSL certificates from Let's Encrypt or ZeroSSL.
  * [Authelia](https://www.authelia.com/) login (optionally two-factor) for all admin interfaces.
  * [CrowdSec](https://www.crowdsec.net/) and a global blocklist to keep out bots and attackers.
  * Logs in VictoriaLogs, and nightly automatic image updates with Watchtower.
  * Every Docker volume is a ZFS dataset, with snapshots and replication backups by [zfs-autobackup](https://github.com/psy0rz/zfs_autobackup).
  * A minimal firewall that does not interfere with Docker.

  Refer to [Installing Docker or Hostbox](#installing-docker-or-hostbox).
* Also easy to install at VPS providers that do not provide an Alpine installer.
* Install time is about 1 minute.

## Why Alpine Linux?

Alpine is one of the best and cleanest Linux distros out there, for running Docker and various other stuff. Packages like the Linux kernel, ZFS support and Docker are not only very up to date, but also very stable.

It's super small, fast and simple. It's not the most versatile distribution, but what it does, it does very well.

Also upgrading to newer releases is quick and painless, in contrast to other distros. And since we use snapshots before upgrading, it's easy to roll back should there be a problem.

For this reason all our boxes run Alpine and just auto-upgrade and reboot every week without problems.

# Installing

The easiest procedure is to write the official image to the disk.

1. Boot a Linux distribution from a CD or a USB drive. If you use a VPS provider, use its rescue boot. Refer to [VPS provider tips](#vps-provider-tips).

   The boot mode of this Linux distribution (UEFI or legacy) is not important. The image contains the two boot modes and always boots. You can also change between UEFI and legacy boot after the installation.

2. Download the imager:
   ```
   # wget https://boot.datux.nl/image
   ```
   *NOTE: This URL goes to https://raw.githubusercontent.com/psy0rz/alpinebox/master/install/installimage.sh*

3. Start the imager. Specify your hard disk:
   ```
   # bash image /dev/sda
   ```
   The imager downloads the image and writes it to the disk. The installation is then complete.

4. Reboot the system. Some VPS providers need a power cycle.

If you have problems during the installation, refer to [VPS provider tips](#vps-provider-tips).

## Login

Console logins do not have a root password. For SSH logins, you must add your keys.

## Growing the disk

**CAUTION: DO THIS PROCEDURE IMMEDIATELY AFTER THE INSTALLATION. THIS PROCEDURE CAN CAUSE DAMAGE TO THE DATA ON THE DISK.**

The image has a fixed size. Thus, you must increase the size of the partition and the ZFS disk.

Run the `grow-disks` script in /root/alpinebox. The script does this procedure automatically. You do not have to reboot.

![image](https://github.com/psy0rz/alpinebox/assets/1179017/7aced4e6-bc15-4be0-803c-69f5717f04af)

## Adding a disk

To add a disk to the zpool as a mirror, run the `add-disk` script in /root/alpinebox.

The script also partitions the disk and installs MBR, UEFI and ZFSBootMenu on it. If the first disk fails, you can then boot from this disk.

Before you add the disk, remove all disks that are not ONLINE from the pool.

## Backups

To make backups with ZFS replication, use my other project: [zfs-autobackup](https://github.com/psy0rz/zfs_autobackup).

## Updates

Before you do Alpine upgrades manually, make a snapshot. For example: `zfs snapshot rpool/ROOT@upgrades1`

If the upgrade fails, use ZFSBootMenu to roll back to the snapshot.

### Automatic updates

The `auto-update` script in /root/alpinebox does the upgrade procedure automatically. The script does these steps:

1. It updates the package index. If there are no new packages, the script stops.
2. It makes a snapshot of rpool/ROOT with [zfs-autobackup](https://github.com/psy0rz/zfs_autobackup). It keeps the 3 latest snapshots, and one snapshot each day for 3 days.
3. It upgrades all packages.
4. If the upgrade is successful, it does a quick reboot into the new system.
5. If the upgrade fails, it rolls back rpool/ROOT to the snapshot and does a quick reboot.

**NOTE: The snapshot contains only rpool/ROOT. The script does not roll back other datasets, for example your Docker data.**

To run the script manually:
```
# /root/alpinebox/auto-update
```

To run the script each week, add a cron job. Run `crontab -e` and add this line:
```
0 4 * * 0 /root/alpinebox/auto-update >> /var/log/auto-update.log 2>&1
```
This line runs the script each Sunday at 04:00. The crond service is enabled by default.

If the system does not boot correctly after an upgrade, use ZFSBootMenu to roll back to the latest `system_upgrade-...` snapshot.

### Quick reboot

The `auto-update` script uses the `quick-reboot` script to restart the system. This script does not do a full reboot. It uses [kexec](https://en.wikipedia.org/wiki/Kexec) to load the new kernel directly from the running system. Thus, the BIOS or UEFI firmware, the hardware checks and ZFSBootMenu are skipped. On physical servers this makes the reboot much faster, because these servers often need minutes for the firmware.

The `quick-reboot` script does these steps:

1. It changes the system to single user mode. This stops all services correctly.
2. It loads the kernel and the initramfs from /boot.
3. It starts the new kernel.

If kexec fails, the script does a usual reboot.

You can also use `quick-reboot` manually:
```
# /root/alpinebox/quick-reboot
```

**NOTE: On older Alpineboxes, kexec is not enabled. To enable it, run these commands:**
```
# zfs set org.zfsbootmenu:commandline="loglevel=4 kexec_load_disabled=0" rpool/ROOT
# apk add kexec-tools
```

# Installing Docker or Hostbox

After you install Alpinebox, go to /root/alpinebox. This directory contains these install scripts:

* `./install-docker`: Installs Docker and the ZFS volume plugin.
* `./install-portainer`: Installs Docker and downloads [Hostbox](#hostbox).
* `./install-portainer-stack`: Installs Docker, Hostbox, zfs-autobackup and the [firewall](#installing-the-firewall).

When the script is complete, it shows the subsequent steps.

## Hostbox

[Hostbox](https://github.com/psy0rz/portainer-templates) turns one Docker server into a hosting platform for many websites and web applications. You create the sites in Portainer from a set of app templates. Each site runs in its own stack. Each Docker volume is a ZFS dataset, so you can snapshot it, back it up and move it to a different server.

The `install-portainer` script clones Hostbox to /root/portainer-templates and creates the `.env` file.

The core stack contains these components:

* **Traefik**: The reverse proxy. It gets free SSL certificates from Let's Encrypt or ZeroSSL, and blocks paths that scanners look for.
* **Portainer**: The Docker web GUI. You use it to create stacks from the templates.
* **Authelia**: The login portal for all admin interfaces, also for Portainer.
* **CrowdSec**: It finds attacks in the logs and bans the IP addresses of the attackers on all sites. It also uses the CrowdSec community blocklist. A web UI shows the alerts and bans.
* **VictoriaLogs**: It keeps the Traefik logs for 30 days.
* **Watchtower**: It updates the images each night.
* **Portal**: It shows the server manager overview page, and the blocked and maintenance pages.

To complete the installation:

1. Go to /root/portainer-templates/core/.
2. Edit the `.env` file. Set `DOMAIN` and the Let's Encrypt or ZeroSSL settings. `DOMAIN` must be a host name, not an IP address.
3. Run `./setup.sh`. Type the admin password when the script asks for it.

   The script creates the secrets, starts the stack, and configures Portainer to use the Authelia login and the app templates.
4. Go to `https://<DOMAIN>/server-manager/` and log in as `admin`. This overview page shows all admin interfaces: Portainer, the Traefik dashboard, the logs and the CrowdSec web UI.
5. In Portainer, click "Login with OAuth". Go to App templates and create a stack.

To change the admin password, run `./setup.sh` again.

These templates are available:

* WordPress (vanilla and LiteSpeed)
* Grav CMS
* Magento 2
* Symfony (LiteSpeed)
* Nextcloud
* Shared MariaDB and phpMyAdmin
* MikoPBX
* MailChannels relay

To move a stack and its ZFS volumes to a different server, use zmigrate.

For more information, for example two-factor login, CrowdSec and the maintenance pages, refer to the [Hostbox README](https://github.com/psy0rz/portainer-templates).

# Installing the firewall

Go to /root/alpinebox and run `./install-firewall`.

This script installs a minimal firewall. The firewall accepts SSH connections only from trusted IP addresses. You set these addresses with ipsets in /etc/ipset.d/.

The firewall does not interfere with Docker. When the script is complete, it shows more information.

# VPS provider tips

This section tells you how to start a rescue environment at some VPS providers. You then use this environment to start the installer.

## Hetzner Cloud VM

In the Hetzner [console](https://console.hetzner.cloud/), request a rescue boot. Refer to [this screenshot](https://github.com/psy0rz/alpinebox/assets/1179017/b3553522-8305-4cc2-86c2-6b86fd8ff61e).

In the rescue environment, use the [installation procedure](#installing).

## Hetzner Robot dedicated server

Use one of these procedures for a Hetzner dedicated server.

### Method 1: Linux rescue system

1. In the Hetzner dashboard, go to the Rescue tab. **Select "Linux"** and activate it.
2. Do the [installation procedure](#installing). Do not reboot.
3. Get access to the installed system:
   * `zpool import -R /mnt rpool` (The first time, this command installs the ZFS tools automatically.)
   * `chroot /mnt`
4. Set the root password or add SSH keys.
5. Exit and reboot.

### Method 2: Hetzner vKVM

This method starts your hard disks as a QEMU VM with VNC access. This method is better for tests and repairs.

1. In the Hetzner dashboard, go to the Rescue tab. **Select vKVM** and activate it.
2. Log in to the SSH rescue environment on port 47772. Log in as root with the password from the Hetzner control panel.
3. Stop vKVM to get access to your hard disk: `systemctl stop vkvm-startup`
4. Do the [installation procedure](#installing). Do not reboot.
5. Start vKVM: `systemctl start vkvm-startup`
6. The server boots. You can access it with the web interface at `https://x.x.x.x:47773/`. The Hetzner control panel shows this address.
7. Log in. Add SSH keys or set the root password.
8. Reboot the rescue shell. The server then boots from its own disk.

#### UEFI boot problems in vKVM

Sometimes the system stays in a UEFI boot loop. If this occurs, disable UEFI:

1. Edit `/opt/vkvm/startqemu`.
2. Remove `-drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_CODE.fd`.
3. Run `systemctl restart vkvm-startup`.

The system then boots in BIOS mode.

## TransIP

Open the console screen in popup mode. Select the Linux rescue boot. Refer to [this screenshot](https://github.com/psy0rz/alpinebox/assets/1179017/0be92242-9ba8-4c2b-99ea-ed6add088a9a).

In the rescue environment, use the [installation procedure](#installing).

After the installation, do a power cycle of the VM. A reboot is not sufficient.

# More info

This installer uses this tutorial as a base: https://docs.zfsbootmenu.org/en/v2.3.x/guides/alpine/uefi.html
