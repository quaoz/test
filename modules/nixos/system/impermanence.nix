{
  inputs,
  config,
  lib,
  self,
  ...
}: let
  inherit (config.garden.hardware) disks;
  cfg = config.garden.system.impermanence;
in {
  options.garden.system.impermanence = {
    enable =
      lib.mkEnableOption "Impermenance"
      // {
        default = disks.impermanence.enable;
      };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        "/var/lib/nixos"
        "/var/lib/bluetooth"
        "/root"
        "/var/lib/netbird"
      ];

      files = lib.flatten [
        "/etc/machine-id"

        # ssh keys
        (lib.optionals (config.services.openssh.enable) (
          builtins.map (x: [x.path "${x.path}.pub"]) config.services.openssh.hostKeys
        ))
      ];
    };
  };
}
