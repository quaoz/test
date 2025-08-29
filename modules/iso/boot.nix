{
  lib,
  pkgs,
  ...
}: {
  boot = {
    # use latest kernel
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

    kernelParams = [
      # show diagnostic messages
      "noquiet"

      # load image to ram
      "toram"
    ];

    # we don't need any raid tools
    swraid.enable = lib.mkForce false;

    # WATCH: https://github.com/NixOS/nixpkgs/issues/58959
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
    ];
  };
}
