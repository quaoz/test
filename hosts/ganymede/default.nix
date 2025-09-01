{
  garden = {
    #pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMOxWr7LsWITmXfclK0QVvYboKsZFYHKoFmvRHVtZWg";

    profiles.server.enable = true;

    hardware = {
      cpu = "intel";

      virtualisation = {
        mode = "qemu";
      };

      disks = {
        enable = true;
        device = "/dev/vda";
      };
    };
  };

  boot.initrd.availableKernelModules = ["uhci_hcd"];
}
