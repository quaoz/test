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
            partitions = {
              ESP = {
                label = "boot";
                priority = 1;
                start = "1M";
                end = cfg.partitions.boot.size;
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "fmask=0022"
                    "dmask=0022"
                  ];
                };
              };

              root = {
                label = "root";
                end = "-${cfg.partitions.swap.size}";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/root" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/";
                    };
                    "/home" = {
                      mountOptions = ["compress=zstd"];
                      mountpoint = "/home";
                    };
                    "/nix" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/nix";
                    };
                    "/persist" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/persist";
                    };
                    "/log" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/var/log";
                    };
                  };
                };
              };

              swap = {
                label = "swap";
                end = "100%";
                content = {
                  type = "swap";
                  randomEncryption = true;
                  resumeDevice = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
