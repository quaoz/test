{pkgs, ...}: {
  imports = [
    # import some common modules, we don't have access to any secrets so can't use the rest
    ../common/nixpkgs.nix
    ../common/nix/default.nix
    ../common/nix/substituters.nix
    ../common/system/revision.nix

    # sane networking defaults
    ../nixos/networking/default.nix
    ../nixos/networking/dns.nix
    ../nixos/networking/systemd.nix
    ../nixos/networking/networkmanager.nix

    # enable systemd boot
    ../nixos/boot/systemd.nix
  ];

  environment.systemPackages = [pkgs.qemu_kvm.ga];
}
