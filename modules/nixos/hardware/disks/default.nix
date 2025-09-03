{
  inputs,
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) types mkEnableOption;
  inherit (self.lib) mkOpt mkOpt';

  cfg = config.garden.hardware.disks;
in {
  options.garden.hardware.disks = {
    enable = mkEnableOption "Default disk configuration";
    device = mkOpt' types.str "The device to format and partition";

    impermanence.enable = mkEnableOption "BTRFS setup for impermanence";

    partitions = {
      boot.size = mkOpt types.str "512M" "The size of the boot partition";
      swap.size = mkOpt types.str "8G" "The size of the swap partition";
    };
  };

  imports = [inputs.disko.nixosModules.disko];

  config = lib.mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          inherit (cfg) device;

          content = {
            type = "gpt";
            partitions = self.lib.harvest {inherit config;} ./_partitions;
          };
        };
      };
    };
  };
}
