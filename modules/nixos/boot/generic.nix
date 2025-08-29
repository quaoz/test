{pkgs, ...}: {
  boot = {
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules = [
        "ahci"
        "ata_piix"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
        "usb_storage"
        "virtio_pci"
        "xhci_pci"
      ];
    };
  };
}
