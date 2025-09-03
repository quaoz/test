{
  garden = {
    #pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMOxWr7LsWITmXfclK0QVvYboKsZFYHKoFmvRHVtZWg";

    profiles.server.enable = true;

    system.networking.wireless.enable = false;

    hardware = {
      cpu = "intel";

      virtualisation = {
        qemu = {
          enable = true;
        };
      };

      disks = {
        enable = true;
        device = "/dev/vda";
      };
    };
  };

  boot.initrd.availableKernelModules = ["uhci_hcd"];
}
