{
  lib,
  self,
  config,
  ...
}: let
  cfg = config.garden.services.remote-builder;

  # TODO: move this and build signing key (modules/common/nix:extra-trusted-public-keys) somewhere
  builder-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQkxMTmEl67/weuxI1vn+WWGNfEV81v3bPMGm9C/sWo";
in {
  options.garden.services.remote-builder = self.lib.mkServiceOpt "remote-builder" {
    enable = config.garden.profiles.server.enable && !config.garden.profiles.slow.enable;
    extraConfig.pubkey = self.lib.mkOpt lib.types.str builder-key "The remote builders pubkey";
  };

  config = lib.mkIf cfg.enable {
    users.users.nix-remote = {
      createHome = true;
      isNormalUser = true;

      group = "nix-remote";
      openssh.authorizedKeys.keys = [cfg.pubkey];
    };

    users.groups.nix-remote = {};

    nix.settings.trusted-users = ["nix-remote"];
  };
}
