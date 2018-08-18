# Arch setup

## Notes

- Use `pacman -Qqe` to list packages.
- Use `pacman -Syu` to update packages.
- Use `pacman -Rns package` to remove package "package".

## Links:

- https://wiki.archlinux.org/index.php/xrandr

## Basic instructions

- https://wiki.archlinux.org/index.php/installation_guide
- https://www.howtoforge.com/tutorial/install-arch-linux-on-virtualbox

start by setting the time,

```bash
timedatectl set-ntp true
```

next we need to partition our disk using `fdisk`,

```bash
fdisk -l
```

then format the selected drive with,

```bash
fdisk /dev/sdX
```

Swap space recommendations:
- https://askubuntu.com/questions/49109/

create three partitions, primary, swap, and logical. note that you have
to create an additional BIOS boot partition if efi isn't available. just
create a 32M partition and change the tag to BIOS boot. then create the
filesystems for each partition.

```bash
mkfs.ext4 /dev/sdX1
mkfs.ext4 /dev/sdX3
mkswap /dev/sdX2
swapon /dev/sdX2
```

next mount the partitions and run `pacstrap` to install arch onto the
new system.

```bash
mount /dev/sdX1 /mnt
mkdir /mnt/home
mount /dev/sdX3 /mnt/home
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
```

switch to the new system and set the root password,

```bash
arch-chroot /mnt
passwd
```

set the default settings (time, locale, hostname, etc.),

```bash
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
vi /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LANGUAGE=en >> /etc/locale.conf
echo hostname > /etc/hostname
vi /etc/hosts
systemctl enable dhcpcd
```

add a bootloader,

```bash
pacman -S grub os-prober
grub-install /dev/sdb
grub-mkconfig -o /boot/grub/grub.cfg
```

logout and restart,

```bash
exit
reboot
```

## Users and additional packages

```bash
pacman -S --needed base-devel wget yajl xorg xorg-xinit xterm dmenu i3 git openssh emacs
```

adding additional users,

```bash
useradd -m -s /bin/bash bijan
passwd bijan
visudo
exit
```

create temporary config,

```bash
echo exec i3 > .xinitrc
startx
```

or add old configs,

```bash
rm .bash*
mkdir Documents
git clone --recurse-submodules -j4 https://github.com/bijn/bash $HOME/documents/bash
for file in $HOME/documents/bash/settings/*; do ln -s $file $HOME/.$(basename ${file%.*}); done
```

## Using AUR

[Wiki](https://wiki.archlinux.org/index.php/Arch_User_Repository).

If PGP signatures cannot be verified because of unknown public keys,
get the key with,

```bash
gpg --recv-key <KEYID>
```

and sign with,

```bash
gpg --lsign <KEYID>
```

[More info](http://allanmcrae.com/2015/01/two-pgp-keyrings-for-package-management-in-arch-linux/).

### aurman

```bash
cd Documents
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
git clone https://github.com/polygamma/aurman.git
cd aurman
makepkg -si
cd
```

some useful packages,

```bash
aurman -S mpv
aurman -S sconsify
aurman -S texlive-core
aurman -S texlive-bin
aurman -S texlive-localmanager-git
```

## Audio setup

to get audio working install the following,

```bash
pacman -S alsa-utils
pacman -S pulseaudio-alsa
pacman -S pulseaudio
pacman -S pavucontrol
reboot
```

for better control use,

```bash
aurman -S ncpamixer
aurman -S pulsemixer
```

For media controls,

```bash
pacman -S playerctl
```

## Wifi setup

find interfaces using,

```bash
ip link show
```

if interface is missing, check drivers using,

```bash
lspci -k
```

both wifi cards i use require broadcom drivers, which were not installed
by default. so we have to install the `broadcom-wl` package using
pacman,

```bash
pacman -S broadcom-wl
modprobe wl
reboot
```

check for the interface again, and enable the interface, `wlp1s0` using,

```bash
ip link set wlp1s0 up
```

if there are problems checked for blocking interfaces,

```bash
rfkill list all
sudo rfkill unblock all
```

otherwise, just create a basic wpa supplicant config,switch to root and
run,

```bash
wpa_supplicant -B -i wlp1s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
wpa_cli
> scan
> scan_results
> add_network
> set_network 0 ssid "ssid"
> set_network 0 psk "psk"
> enable_network 0
> save_config
```

rebooting may be required, if you do reboot you must start
wpa supplicant again. as root, do:

```bash
wpa_supplicant -B -i wlp1s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
wpa_cli
> enable_network 0
```

can also add wpa_supplicant to systemd,

```bash
systemctl enable wpa_supplicant@wlp1s0
```

but this requires that you have a config named `wpa_supplicant-wlp1s0.conf`
in `/etc/wpa_supplicant.`

more info [here](https://wiki.archlinux.org/index.php/WPA_supplicant).

## Misc

### Document viewer

Zathura seems to work pretty well for PDFs.

```bash
aurman -S zathura
aurman -S zathura-pdf-mupdf
```

### Media

Play youtube videos in Arch.

```bash
aurman -S mpv
aurman -S youtube-dl
```

### Font

If some unicode characters are not displaying properly in applications
like Chrome,

```bash
pacman -S ttf-dejavu
```

### Browsers

Google Chrome

```bash
aurman -S google-chrome
```

qutebrowser for vim like bindings

```bash
pacman -S qutebrowser
```

Others:
- surf
- vimb
- uzbl
