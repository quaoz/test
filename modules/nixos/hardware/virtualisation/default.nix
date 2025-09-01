{
  lib,
  self,
  ...
}: {
  options.garden.hardware.virtualisation = {
    mode = self.lib.mkOpt (lib.types.nullOr (lib.types.enum ["qemu"])) null "The system virtualisation mode";

    scsi.enable = lib.mkEnableOption "Virtio SCSI module";
  };
}
