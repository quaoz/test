{
  # import some common modules, we don't have access to any secrets so can't use the rest
  imports = [
    ../common/nixpkgs.nix
    ../common/nix/default.nix
    ../common/nix/substituters.nix
    ../common/system/revision.nix
  ];
}
