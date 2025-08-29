{
  lib,
  pkgs,
  ...
}: {
  nix.package = lib.mkForce pkgs.lixPackageSets.latest.lix;
}
