{
  garden = {
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMOxWr7LsWITmXfclK0QVvYboKsZFYHKoFmvRHVtZWg";

    profiles.server.enable = true;

    services = {
      blocky.enable = true;
      headscale.enable = true;
      nginx.enable = true;
      unbound.enable = true;
    };

    hardware = {
      cpu = "intel";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];
}
