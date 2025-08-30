{
  imports = [
    # import some common modules, we don't have access to any secrets so can't use the rest
    ../common/nixpkgs.nix

    ../common/system/revision.nix
  ];
}
