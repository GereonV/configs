# Who is this for?

Primarily me! This is just a partial snapshot of the wiki with parts I consider relevant.
Hence, this is an opinionated document which contains assumptions like using 64-bit UEFI and having a USB flash drive to wipe clean.
When following this, decide on whether you want to look up more information for each step.

The information is provided as is and there's no warranty or correctness guarantee.
Purely best-effort with references checked on 2025-11-30.

# Preparation

1. Download `archlinux-x86_64.iso` from [any mirror](https://archlinux.org/download/#download-mirrors)\
**Verify the download's integrity!**
    - Checksums should be downloaded directly from [archlinux.org](https://archlinux.org/download/#http-downloads)
    - From an Arch-installation you can check the PGP signature like this:

      ```bash
      pacman-key --verify archlinux-x86_64.iso.sig
      ```
1. Install the image onto a USB drive (**not parition**, can be found in `/dev/disk/by-id/`):

   ```bash
   dd bs=4M if=archlinux-x86_64.iso of=/dev/... conv=fsync oflag=direct status=progress
   ```
    - See [this](https://wiki.archlinux.org/title/USB_flash_installation_medium#In_Windows) for Windows

1. Disable *Secure Boot* in the UEFI firmware and boot into the installation medium

# Live environment

1. **Optional:** Set up terminal
    - On non-US keyboards configure it to use your layout (one of `localectl list-keymaps`) using `loadkeys`.\
    Example:

      ```bash
      loadkeys de-latin1
      ```
    - Use a different font (one of `ls /usr/share/kbd/consolefonts/`) using `setfont`.\
    Example:

      ```bash
      setfont ter-132b
      ```
1. If not using ethernet [connect to the internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet) in the desired way
1. Partition the disk you want to install Arch on (eg. using `fdisk` or the TUI `cfdisk`):
    - *EFI System Partition* can be tiny (a few MiB) but for dual-boot setups or just to be safe use ~512 MiB
    - **Optional:** *Linux swap* should be at least 4 MiB to be effective, usually half of the system's memory is good
        - This is not needed if you intend to use a [swap file](https://wiki.archlinux.org/title/Swap#Swap_file) or [`zram`](https://wiki.archlinux.org/title/Zram)
    - *Linux root x86-64* corresponds to the root of the filesystem and should be sized accordingly
        - If other partitions will be mounted to store data, this doesn't need to be as large
1. Format the partitions you created with the correct filesystems:
    - FAT32 for the ESP: `mkfs.fat -F 32 /dev/...`
    - Swap area for the swap partition: `mkswap /dev/...`
    - Anything you want for the root partition: eg. `mkfs.ext4 /dev/...` for EXT4
1. **Optional:** Use [`reflector`](https://wiki.archlinux.org/title/Reflector) to fetch an optimized list of package mirror servers
    - `/etc/pacman.d/mirrorlist` will be copied over by to the new installation by `pacstrap`
1. Mount the filesystem of the new installation somewhere so `genfstab` can be used later on.\
   Example:

   ```bash
   mount /dev/... /mnt  # root partition
   mount --mkdir /dev/... /mnt/boot  # ESP
   swapon /dev/...  # swap partition
   ```
1. Install essential packages onto the system with `pacstrap`:
    - `base` for essential Arch packages
    - a Linux kernel (eg. `linux` or `linux-lts`) unless you're installing in a container
    - firmware depending on the hardware (unless in a VM or container)
        - `linux-firmware` bundles the most common packages - **highly recommended**
        - Laptop on-board audio or wireless network devices may require additional firmware
    - CPU stability and security microcode updates: `amd-ucode` or `intel-ucode`
    - file system modules for partitions the Linux kernel can't handle
    - if wireless internet connections are required, `iwd` or `wpa_supplicant` need to be installed
        - for an all-in-one solution use `networkmanager`
    - a simple terminal text editor (ie. prefer a plain `vim` over a configured `nvim`) to edit system configuration
    - you probably want Linux and Posix man pages from `man-pages` and `man-db` to view them
        - also `texinfo` provides more comprehensive documentation for GNU software
    - you may already install anything you'll need on the final system because it's effectively a `pacman -S`

   ```bash
   pacstrap -K /mnt base linux linux-firmware ...
   ```
1. Generate the file system table to automatically mount partitions using `genfstab`

   ```bash
   genfstab -U /mnt >> /mnt/etc/fstab
   ```
1. Enter the system using `arch-chroot` (`chroot` + mount important stuff)

   ```bash
   arch-chroot /mnt
   ```

# Installed system

1. Set your local time zone, generate hardware clock metadata and enable time synchronization using NTP.\
   Example:

   ```bash
   ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
   hwclock --systohc
   systemctl enable systemd-timesyncd.service
   ```
    - When dual-booting Windows, beware it expects the hardware clock to be *localtime* - it's desirable to configure either OS to use the other time standard!
1. Set up `glibc` locales (**use UTF-8!**):
    1. Uncomment `en_US.UTF-8 UTF-8` and additionally any others you want in `/etc/locale.gen`
    1. Run `locale-gen` to generate the configured locales
    1. Set the system-wide locales to use in `/etc/locale.conf`
        - the default locale `LANG` should be set, so all other settings inherit it
        - the fallback `LANGUAGE` should be set to a colon-separated list of fallbacks if `LANG` isn't `en_US`
            - put the `C` locale between English and non-English items: eg. `en_GB:en:de_DE.UTF-8`
        - `LC_TIME=en_DK.UTF-8` conforms to the ISO 8601 date format
        - refer to [locale](https://man.archlinux.org/man/locale.7.en) for the other settings
          (`LC_CTYPE`, `LC_NUMERIC`, `LC_TIME`, `LC_COLLATE`, `LC_MONETARY`, `LC_MESSAGES`, `LC_PAPER`, `LC_NAME`, `LC_ADDRESS`, `LC_TELEPHONE`, `LC_MEASUREMENT`, `LC_IDENTIFICATION`)
1. **Optional:** Make terminal configuration persistent in `/etc/vconsole.conf`.\
   Example:

   ```
   KEYMAP=de-latin1
   FONT=ter-132b
   ```
1. **Optional but recommeded:** Set the local hostname in `/etc/hostname`
    - Other devices can resolve your hostname out-of-the-box using mDNS or [Samba](https://wiki.archlinux.org/title/Samba) if you set it up
1. Finish network setup (eg. reconnect to Wi-Fi or run `systemctl enable NetworkManager`)
1. Set the root password using `passwd`
1. Install a boot loader according to your requirements.\
   Example using GRUB:

   ```bash
   pacman -S grub efibootmgr>\
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
   grub-mkconfig -o /boot/grub/grub.cfg
   ```
1. Reboot the system by exiting the chroot and running `reboot`; you should be able to log in as `root`
    - during the reboot you may reenable *Secure Boot*

# First steps

1. Create a user-account and set it's password:

   ```bash
   useradd --create-home --groups wheel [username]
   passwd [username]
   EDITOR=vim visudo  # optional to allow privilege elevation using `sudo`
   ```
1. Set up a firewall using [`nftables`](https://wiki.archlinux.org/title/Nftables)
    - Make sure to run `systemctl enable nftables.service`!
1. Configure a GUI:
    1. Install [drivers for your graphics card](https://wiki.archlinux.org/title/Xorg#Driver_installation)
        - Look out for vendor- or version-specific requirements (especially for [NVIDIA](https://wiki.archlinux.org/title/NVIDIA#Wayland_configuration))
    1. Install a Wayland compositor (equivalent to window manager + compositor in X) like `hyprland`
    1. **Optional:** Install add-ons, which depends on the compositor, but look into:
        - a[display manager](https://wiki.archlinux.org/title/Wayland#Display_managers) like `greetd`
          (particularly with something like `tuigreet`, `wlgreet` or `regreet`)
        - a launcher/menu like `fuzzel` (which is `dmenu` compatible)
        - a notification server like `mako`, `fnott`, `dunst` or `swaync`
        - a multi-monitor manager like `wlay`
        - a screenshot-tool like `grim` with `slurp`
        - a color-picker like `hyprpicker`
        - clipboard tools like `wl-clipboard` for the command-line or a manager like `cliphist`
        - the [wob](https://github.com/francma/wob) overlay bar
        - a bar like `waybar` (sometimes with an independant content generator)
        - a screenlocker like `waylock`
    1. Install `pipewire` for various multimedia needs in addition to:
        - `pipewire-audio` for an audio server and Bluetooth audio devices
            - and `pipewire-alsa` to proxy the kernel's ALSA API for unaware audio clients
            - and `pipewire-pulse` for clients only compatible with PulseAudio
            - and `pipewire-jack` for clients only compatible with JACK
        - `xdg-desktop-portal` and a backend compatible with your compositor (eg. `xdg-desktop-portal-hyprland`) for screen sharing, a native file dialog, secret-management, look-and-feel settings such as color scheme, and URI or MIME-type handling
            - You can test whether everything works on [Mozilla's test website](https://mozilla.github.io/webrtc-landing/gum_test.html)
    1. [Install fonts and configure fonts](https://wiki.archlinux.org/title/General_recommendations#Fonts)
    1. Configure your applications and their frameworks like GTK and Qt
