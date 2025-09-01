{
  gum,
  vim,
  disko,
  parted,
  writeShellApplication,
}:
writeShellApplication {
  name = "easy-install";

  runtimeInputs = [
    gum
    vim
    parted
    disko
  ];

  text = builtins.readFile ./easy-install.sh;
}
