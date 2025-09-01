{pkgs, ...}: {
  boot = {
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      # common kernel modules
      availableKernelModules = [
        # SATA
        "ahci"
        "ata_piix"

        # USB
        "uas"
        "usb_storage"
        "ehci_pci"
        "xhci_pci"

        # SCSI
        "sd_mod"
        "sr_mod"

        # virtio
        "virtio_pci"
      ];
    };
  };
}
