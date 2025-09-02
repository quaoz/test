{pkgs, config, ...}: let
  easy-install = pkgs.writeShellApplication {
    name = "easy-install";

    runtimeInputs = with pkgs; [
      gum
      vim
      parted
      (disko.override {
        nix = config.nix.package;
      })
    ];

    text = builtins.readFile ./easy-install.sh;
  };
in {
  environment.systemPackages = [
    easy-install
  ];
}
