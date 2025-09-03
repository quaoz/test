{config, ...}: let
  cfg = config.garden.hardware.disks;
in {
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
}
