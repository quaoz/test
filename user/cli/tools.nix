{pkgs, ...}: {
  # common miscellaneous tools
  home.packages = with pkgs; [
    file
    jq
    rsync
    tree
    unzip
  ];
}
