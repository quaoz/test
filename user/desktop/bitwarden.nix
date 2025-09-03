{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig.users.users.${osConfig.me.username}) home;
in {
  # password manager
  home = lib.mkIf osConfig.garden.profiles.desktop.enable {
    packages = with pkgs; [
      bitwarden-desktop
      # WATCH: https://github.com/NixOS/nixpkgs/issues/339576
      # bitwarden-cli
    ];

    sessionVariables = {
      # use bitwarden ssh-agent
      SSH_AUTH_SOCK = "${home}/.bitwarden-ssh-agent.sock";
    };
  };
}
