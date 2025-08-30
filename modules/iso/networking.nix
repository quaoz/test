{
  lib,
  config,
  ...
}: let
  inherit (config.me) pubkey;
in {
  imports = [
    ../nixos/networking/default.nix
    ../nixos/networking/dns.nix
    ../nixos/networking/iwd.nix
    ../nixos/networking/systemd.nix
    ../nixos/networking/networkmanager.nix
  ];

  # enable ssh
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [pubkey];
}
