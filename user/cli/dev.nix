{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      coreutils
      just
      tokei
      lldb
    ];

    # TODO: re-enable
    #file.".lldbinit".text = with cell.packages; ''
    #  command script import ${lldbinit}/lldbinit.py
    #'';
  };
}
