{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkForce mkDefault;
in {
  imports = [
    (inputs.nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
    #(inputs.nixpkgs.outPath + "/nixos/modules/profiles/perlless.nix")
  ];

  # disable documentation
  documentation = {
    enable = mkForce false;
    dev.enable = mkForce false;
    doc.enable = mkForce false;
    info.enable = mkForce false;
    nixos.enable = mkForce false;

    man = {
      enable = false;
      man-db.enable = false;
    };
  };

  environment.defaultPackages = mkDefault [];

  # don't include nixpkgs in our iso
  system.installer.channel.enable = false;
}
