{
  gum,
  vim,
  parted,
  writeShellApplication,
}:
writeShellApplication {
  name = "easy-install";

  runtimeInputs = [
    gum
    vim
    parted
  ];

  text = builtins.readFile ./easy-install.sh;
}
