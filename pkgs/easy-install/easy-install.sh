#!/usr/bin/env bash

set -euxo pipefail

# check network connection
if [[ $(nmcli networking connectivity check) != "full" ]]; then
    mode=$(gum choose --header "No network connection. Attempt to configure:" wifi ethernet)

    if [[ $mode == "wifi" ]]; then
        ssid=$(nmcli -g SSID dev wifi | gum choose --header "Select access point")
        pass=$(gum input --password --header "Enter password for $ssid" --placeholder "password")

        nmcli dev wifi con "$ssid" password "$pass" name "installer-con-$ssid"
    elif [[ $mode == "ethernet" ]]; then
        ifname=$(nmcli -g DEVICE dev | gum choose --header "Select interface to use")
        ipaddr=$(gum input --header "Enter host ip address" --placeholder "x.x.x.x")
        ipcidr=$(gum input --header "Enter ip cidr" --value "24")
        gateway=$(gum input --header "Enter gateway" --value "${ipaddr%.*}.1")

        nmcli con add con-name "installer-con-${ifname}" ifname "$ifname" ipv4.addresses "$ipaddr/$ipcidr" ipv4.gateway "$gateway" ipv4.dns "9.9.9.9" ipv4.method "manual" type "ethernet"
    fi

    if [[ $(nmcli networking connectivity check) != "full" ]]; then
        echo "Connection failed"
        exit 1
    fi
fi

# get some information from the user
hostname=$(gum input --header "Enter hostname" --value "$(hostname)")
drive=$(lsblk -nlo PATH | gum choose --header "Select drive to install to")

# create some partitions
parted "$drive" -- mklabel gpt
parted "$drive" -- mkpart boot fat32 1MB 1024MB
parted "$drive" -- mkpart root btrfs 1024MB -8GB
parted "$drive" -- mkpart swap linux-swap -8GB 100%
parted "$drive" -- set 1 esp on

# determine partition prefix based on drive type
if [[ $drive == *"nvme"* ]]; then
    # nvme dirves like /dev/nvme0n1p1
    boot_part="${drive}p1"
    root_part="${drive}p2"
    swap_part="${drive}p3"
else
    # handle /dev/sda1 style drives
    boot_part="${drive}1"
    root_part="${drive}2"
    swap_part="${drive}3"
fi

# format the partitions
mkfs.fat -F32 -n boot "$boot_part"
mkfs.btrfs -L root "$root_part"
mkswap -L swap "$swap_part"
swapon "$swap_part"

# mount the partitions whilst ensuring the directories exist
mkdir -p /mnt
mount "$root_part" /mnt
mkdir -p /mnt/boot
mount "$boot_part" /mnt/boot

# copy across the iso's nixos flake to the target system
mkdir -p /mnt/etc/nixos
cp -rT /iso/flake /mnt/etc/nixos

# even if we don't need a new host we are going to have to generate a new hardware config
nixos-generate-config --root /mnt --show-hardware-config >/mnt/etc/nixos/hosts/"$hostname"/hardware.nix

# setup the git repository for the nixos configuration
git -C /mnt/etc/nixos init
git -C /mnt/etc/nixos remote add origin ssh://git@github.com/quaoz/flake.git
(
    git -C /mnt/etc/nixos fetch &&
        git -C /mnt/etc/nixos reset "origin/HEAD" &&
        git -C /mnt/etc/nixos branch --set-upstream-to=origin/main main
) || true

# create some ssh keys with no passphrases
mkdir -p /mnt/etc/ssh
ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""
gum format --type template "{{ Bold \"pubkey\" }}: {{ Faint \"$(cat /mnt/etc/ssh/ssh_host_ed25519_key.pub)\" }}"

# setup our installer args based off of our configuration
# this is concept is taken from https://github.com/lilyinstarlight/foosteros/blob/0d40c72ac4e81c517a7aa926b2a1fb4389124ff7/installer/default.nix
installArgs=(--no-channel-copy)
if [ "$(nix eval "/mnt/etc/nixos#nixosConfigurations.$hostname.config.users.mutableUsers")" = "false" ]; then
    installArgs+=(--no-root-password)
fi

echo "When you are ready to install, run the following command:"
echo nixos-install --flake "/mnt/etc/nixos#$hostname" "''${installArgs[*]}"
