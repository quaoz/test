{pkgs, ...}: let
  easy-install = pkgs.writeShellApplication {
    name = "easy-install";

    runtimeInputs = with pkgs; [
      gum
      parted
    ];

    text = builtins.readFile ./easy-install.sh;
  };
in {
  environment.systemPackages = [
    easy-install
  ];
}
