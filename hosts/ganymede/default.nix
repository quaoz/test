{
  garden = {
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9hyJQXOUF6S0K64FBKptZTVwJ42ntVqWCDkJyKno4M";

    profiles.server.enable = true;

    system = {
      networking.wireless.enable = false;
      impermanence.enable = true;
    };

    hardware = {
      cpu = "intel";

      disks = {
        enable = true;
        impermanence.enable = true;
        device = "/dev/vda";
      };

      virtualisation.qemu = {
        enable = true;
      };
    };
  };

  boot.initrd.availableKernelModules = ["uhci_hcd"];
}
