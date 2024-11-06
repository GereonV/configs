#!/usr/bin/env bash
german=0 # non-zero for german
efi= # optional: partition "EFI System"
main= # partition "Linux filesystem" (MBR "Linux")
swap= # optional: partition "Linux swap" (MBR "Linux swap / ...")
manufacturer= # optional: amd|intel
hostname=
rootpasswd= # please confirm this is a valid password!
username= # optional
userpasswd= # iff username is set
echo "edit the variables at the top of the file and remove this output!"
exit

# checking config
if [[ "$(id -ru)" -ne 0 ]] || ! type archinstall &> /dev/null
then
	echo "error: not installing" >&2
	exit 1
elif [[ -n "${efi}" ]] && ! stat /sys/firmware/efi/efivars &> /dev/null
then
	echo "error: not an UEFI system" >&2
	exit 1
fi
for part in "${efi}" "${main}" "${swap}"
do
	if [[ -n "${part}" && ! -b "${part}" ]]
	then
		echo "error: not a block device: ${part}" >&2
		exit 1
	fi
done
if [[ ! "${manufacturer}" =~ ^(amd|intel)?$ ]]
then
	echo "error: invalid manufacturer: ${manufacturer}" >&2
	exit 1
elif [[ ! "${hostname}" =~ ^[A-Za-z][A-Za-z0-9-]*$ ]]
then
	echo "error: invalid hostname" >&2
	exit 1
elif [[ -n "${username}" && -z "${userpasswd}" || -z "${rootpasswd}" ]]
then
	echo "error: invalid (empty) password" >&2
	exit 1
fi
((german)) && loadkeys de-latin1
timedatectl set-ntp true
set -e

# filesystem
echo "FORMATTING..."
trap 'echo "error: initializing filesystems failed" >&2' EXIT
[[ -z "${efi}" ]] || mkfs.fat -F32 "${efi}"
[[ -z "${swap}" ]] || mkswap "${swap}"
mkfs.ext4 "${main}"
echo "MOUNTING..."
mount "${main}" /mnt
[[ -z "${swap}" ]] || swapon "${swap}"
mkdir /mnt/boot /mnt/etc
[[ -z "${efi}" ]] || mount "${efi}" /mnt/boot
genfstab -U /mnt > /mnt/etc/fstab

# actual setup
echo "SETTING UP ROOT..."
trap 'echo "error: failed to setup root" >&2' EXIT
pacstrap /mnt base linux linux-firmware base-devel grub ${efi:+efibootmgr} networkmanager ${manufacturer:+${manufacturer}-ucode}
trap - EXIT

arch-chroot /mnt << CHROOTEOF
set -e
echo "CONFIGURING..."
trap 'echo "error: failed to setup root" >&2' EXIT
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
sed -i 's/^#en_US.UTF-8 UTF-8[[:space:]]*$/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
! ((german)) || echo 'KEYMAP=de-latin1' >> /etc/vconsole.conf
echo "${hostname}" > /etc/hostname
cat >> /etc/hosts <<- EOF
	127.0.0.1	localhost
	::1		localhost
	127.0.1.1	${hostname}
EOF
systemctl enable NetworkManager
echo "CHANGING ROOT PASSWORD..."
trap 'echo "error: failed to change root password" >&2' EXIT
echo -e "${rootpasswd}\n${rootpasswd}" | passwd
if [[ -n "${username}" ]]
then
	echo "CREATING USER '${username}'..."
	trap 'echo "error: failed to create user account" >&2' EXIT
	useradd -mG wheel "${username}"
	echo -e "${userpasswd}\n${userpasswd}" | passwd "${username}"
fi
echo "INSTALLING GRUB..."
trap 'echo "error: grub-install failed" >&2' EXIT
if [[ -n "${efi}" ]]
then
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
	grub-install --target=i386-pc ${main%%[0-9]}
fi
trap 'echo "error: grub-mkconfig failed" >&2' EXIT
grub-mkconfig -o /boot/grub/grub.cfg
CHROOTEOF
set +e

echo "DELETING 'install.sh'..."
rm "${BASH_SOURCE[0]}" || echo 'deletion failed - please delete the script manually to keep your credentials safe' >&2
echo "tip: run 'arch-chroot /mnt' or 'shutdown now'"
