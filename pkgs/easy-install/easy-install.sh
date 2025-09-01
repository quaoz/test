#!/usr/bin/env bash

set -euxo pipefail

# alternatively use '/iso/flake' to install based of the flake when the iso was created
FLAKE_URL="github:quaoz/flake"

gum format --type markdown "# This script _will_ make irrevocable and destructive changes to your system."
gum confirm --default=no "Are you sure you want to continue?" || exit 0

# check for root
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0"
fi

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
        nmcli con up "installer-con-${ifname}"
    fi

    if [[ $(nmcli networking connectivity check) != "full" ]]; then
        echo "failed to establish network connection" >&2
        exit 1
    fi
fi

hostname=$(gum input --header "Enter hostname" --value "$(hostname)")

use_disko=false
if [[ "$(nix eval "$FLAKE_URL#nixosConfigurations.$hostname.config" --apply 'builtins.hasAttr "disko"')" == "true" ]]; then
    if [[ "$(nix eval "$FLAKE_URL#nixosConfigurations.$hostname.config.disko.devices.disk" --apply 'x: x != {}')" == "true" ]]; then
        use_disko=true
    elif ! gum confirm "$hostname has empty disko configuration. Proceed with manual formatting?"; then
        exit 0
    fi
fi

if $use_disko; then
    disko --mode "destroy,format,mount" --flake "$FLAKE_URL#nixosConfigurations.$hostname"
else
    drive=$(lsblk -nlo PATH | gum choose --header "Select drive to install to")

    # create some partitions
    parted "$drive" -- mklabel gpt
    parted "$drive" -- mkpart boot fat32 1MB 512MB
    parted "$drive" -- mkpart root btrfs 512MB -8GB
    parted "$drive" -- mkpart swap linux-swap -8GB 100%
    parted "$drive" -- set 1 esp on

    # determine partition prefix based on drive type
    if [[ $drive == *"nvme"* ]]; then
        # nvme drives like /dev/nvme0n1p1
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
    mkfs.btrfs -f -L root "$root_part"
    mkswap -L swap "$swap_part"
    swapon "$swap_part"

    # mount the partitions whilst ensuring the directories exist
    mkdir -p /mnt
    mount "$root_part" /mnt
    mkdir -p /mnt/boot
    mount "$boot_part" /mnt/boot
fi

# create some ssh keys with no passphrases
mkdir -p /mnt/etc/ssh
ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N "" -C ""
gum format --type template "{{ Bold \"pubkey\" }}: {{ Faint \"$(cat /mnt/etc/ssh/ssh_host_ed25519_key.pub)\" }}"

# setup our installer args based off of our configuration
# this is concept is taken from https://github.com/lilyinstarlight/foosteros/blob/0d40c72ac4e81c517a7aa926b2a1fb4389124ff7/installer/default.nix
installArgs=(--no-channel-copy)
if [ "$(nix eval "$FLAKE_URL#nixosConfigurations.$hostname.config.users.mutableUsers")" = "false" ]; then
    installArgs+=(--no-root-password)
fi

gum format --type markdown <<EOF
Before installing you probably want to rekey your secrets and check the hardware configuration.
> pubkey: $(cat /mnt/etc/ssh/ssh_host_ed25519_key.pub)
When you are ready to install, run the following command:
EOF
gum format --type code --language sh "nixos-install --flake \"$FLAKE_URL#$hostname\" \"${installArgs[*]}\""
