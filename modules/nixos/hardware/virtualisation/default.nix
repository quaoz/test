{lib, ...}: {
  options.garden.hardware.virtualisation = {
    qemu = {
      enable = lib.mkEnableOption "QEMU";
      guestAgent.enable =
        lib.mkEnableOption "QEMU guest agent"
        // {
          default = true;
        };
    };

    scsi.enable = lib.mkEnableOption "Virtio SCSI module";
  };
}
