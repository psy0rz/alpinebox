# VPS provider tips

This page tells you how to start a rescue environment at some VPS providers. You then use this environment to start the installer.

## Hetzner Cloud VM

In the Hetzner [console](https://console.hetzner.cloud/), request a rescue boot. Refer to [this screenshot](https://github.com/psy0rz/alpinebox/assets/1179017/b3553522-8305-4cc2-86c2-6b86fd8ff61e).

In the rescue environment, use the [installation procedure](README.md#installing).

## Hetzner Robot dedicated server

Use one of these procedures for a Hetzner dedicated server.

### Method 1: Linux rescue system

1. In the Hetzner dashboard, go to the Rescue tab. **Select "Linux"** and activate it.
2. Do the [installation procedure](README.md#installing). Do not reboot.
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
4. Do the [installation procedure](README.md#installing). Do not reboot.
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

In the rescue environment, use the [installation procedure](README.md#installing).

After the installation, do a power cycle of the VM. A reboot is not sufficient.

