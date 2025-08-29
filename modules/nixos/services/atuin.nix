{
  lib,
  self,
  config,
  ...
}: let
  cfg = config.garden.services.atuin;
in {
  options.garden.services.atuin = self.lib.mkServiceOpt "atuin" {
    port = "8888";
    domain = "atuin.${config.garden.domain}";
  };

  config = lib.mkIf cfg.enable {
    services.atuin = {
      enable = true;
    };
  };
}
