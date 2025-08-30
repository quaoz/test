{
  lib,
  pkgs,
  ...
}: {
  # use cached nix to speed up build
  nix.package = lib.mkForce pkgs.lixPackageSets.latest.lix;
}
