{
  nix,
  gum,
  vim,
  parted,
  nixos-install-tools,
  writeShellApplication,
}:
writeShellApplication {
  name = "easy-install";

  runtimeInputs = [
    nix
    gum
    vim
    parted
    nixos-install-tools
  ];

  text = builtins.readFile ./evil.sh;
}
