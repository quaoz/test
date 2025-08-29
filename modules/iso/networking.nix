{
  lib,
  config,
  ...
}: let
  inherit (config.garden) pubkey;
in {
  # enable ssh
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [pubkey];
}
