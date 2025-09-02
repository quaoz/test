{config, ...}: {
  imports = [
    ../common/nixpkgs.nix
  ];

  nixpkgs.overlays = [
    (prev: _: {
      nixVersions =
        prev.nixVersion
        // {
          stable = config.nix.package;
        };
    })
  ];
}
