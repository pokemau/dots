#!/bin/bash


set -e

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware git sudo grub efibootmgr vim networkmanager intel-ucode bluez bluez-utils

genfstab /mnt > /mnt/etc/fstab

cat > /mnt/setup.sh << 'EOF'
#!/bin/bash

set -e

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

read -p "Enter hostname: " hostname
echo "$hostname" > /etc/hostname

echo "Setting root password..."
passwd

useradd -m -G wheel -s /bin/bash mau
echo "Setting password for user 'mau'..."
passwd mau

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

pacman -S --noconfirm gnome gdm dosfstools mtools firefox alacritty ghostty kitty

systemctl enable NetworkManager
systemctl enable gdm.service
systemctl enable bluetooth

echo "Installing and configuring GRUB..."
read -p "Enter the disk device (e.g., /dev/sda): " disk
grub-install "$disk"
grub-mkconfig -o /boot/grub/grub.cfg

echo ""
echo "Setup complete! Cleaning up..."
rm /setup.sh
EOF

chmod +x /mnt/setup.sh

arch-chroot /mnt /setup.sh

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Unmounting filesystems..."
umount -a || true

echo ""
read -p "Press Enter to shutdown the system..."
shutdown now
