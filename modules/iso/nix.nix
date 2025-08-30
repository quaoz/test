{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/nix/default.nix
    ../common/nix/substituters.nix
  ];

  nix = {
    # use cached nix to speed up build
    package = lib.mkForce pkgs.lixPackageSets.latest.lix;

    registry = lib.mkForce {
      nixpkgs = {flake = inputs.nixpkgs;};
    };

    nixPath = lib.mkForce ["nixpkgs=flake:${inputs.nixpkgs.outPath}"];
  };
}
