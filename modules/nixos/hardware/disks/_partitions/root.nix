{config, ...}: let
  cfg = config.garden.hardware.disks;
  rootPart = config.disko.devices.disk.main.content.partitions.root.device;
in {
  root = {
    label = "root";
    priority = 2;
    end = "-${cfg.partitions.swap.size}";

    content =
      {
        type = "btrfs";
        extraArgs = ["-f"];
      }
      // (
        if cfg.impermenance.enable
        then {
          # create an empty snapshot
          postCreateHook = ''
            mnt=$(mktemp -d)
            mount ${rootPart} "$mnt" -o subvol=/
            trap 'umount $mnt; rm -rf $mnt' EXIT
            btrfs subvolume snapshot -r "$mnt/root" "$mnt/root-blank"
          '';

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
        }
        else {
          mountOptions = ["compress=zstd" "noatime"];
          mountpoint = "/";
        }
      );
  };
}
