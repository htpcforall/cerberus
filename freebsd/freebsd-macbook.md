# Freebsd macbook install

* Download iso file
* Burn to disc
* Insert disc restart mac and hold down alt to boot into efi mode

## root on zfs

Select root on zfs during install

* encrypt discs
* encrypt swap
* swap size 8gig

## set the root password

* set the root password

## create new user

create new user

```
useradd
```

* add new user to wheel group

## single user mode require root password

change single user mode to requite root password
change setting from secure to insecure to require root password

edit /etc/ttys

```
sudo nano /etc/ttys
```

* change settings to insecure

```
console none unknown off insecure
```

## bootstrap the system

To bootstrap the system, run:

```
# /usr/sbin/pkg
```

## sudo

install sudo 

```
# pkg install sudo
```

edit /etc/sudoers

```
# visudo
```

add your user to the sudoers file, replace username with your username

```
%username   ALL=(ALL:ALL) ALL
```

## xorg

instal xorg

```
# pkg install xorg
```

```
pkg install -y xinit xf86-input-keyboard xf86-input-mouse
```

## fonts

install truetype fonts

```
# pkg install urwfonts
```

## i3wm tiling window manager

install i3wm

```
# pkg install -y i3 i3lock i3status
# pkg install dmenu
```

## /etc/rc.conf

edit /etc/rc.conf

```
moused_enable="YES"

# powerd: hiadaptive speed while on AC power, adaptive while on battery power
powerd_enable="YES"
powerd_flags="-a hiadaptive -b adaptive"

# Synchronize system time
ntpd_enable="YES"
# Let ntpd make time jumps larger than 1000sec
ntpd_flags="-g"

hald_enable="YES"
dbus_enable="YES"
```

## /etc/sysctl.conf

edit /etc/sysctl.conf

```
# Enhance shared memory X11 interface
kern.ipc.shmmax=67108864
kern.ipc.shmall=32768

# Enhance desktop responsiveness under high CPU use (200/224)
kern.sched.preempt_thresh=224

# Bump up maximum number of open files
kern.maxfiles=200000

# Disable PC Speaker
hw.syscons.bell=0

# Shared memory for Chromium
kern.ipc.shm_allow_removed=1
```

## /etc/pf.conf

pf firewall

reload pf firewall

```
# pfctl -f /etc/pf.conf
```

## /boot/loader.conf

load audio driver at boot

edit /boot/loader.conf

```
# nano /boot/loader.conf
```

add the following line

```
snd_hda_load="YES"
```