{pkgs, ...}: {
  # modern replacements for various tools
  home.packages = with pkgs; [
    # cut (and sometimes awk) --> choose
    choose

    # du --> dust
    dust

    # df --> duf
    duf

    # jq --> jql
    jql

    # tar | zip | ... --> ouch
    ouch

    # sed --> sd
    sd

    # ps --> procs
    procs
  ];

  programs = {
    # cat --> bat
    bat = {enable = true;};

    # top --> bottom
    bottom = {enable = true;};

    # tree (kinda) --> broot
    broot = {enable = true;};

    # ls --> eza
    eza = {
      enable = true;
      icons = "auto";
      git = true;

      extraOptions = [
        "--all"
        "--header"
        "--no-permissions"
        "--octal-permissions"
        "--sort=type"
        "--classify=auto"
      ];
    };

    # find --> fd
    fd = {
      enable = true;
      hidden = true;

      ignores = [
        ".git/"
        ".direnv/"
      ];
    };

    # idrk
    fzf = {
      enable = true;

      defaultCommand = "fd --type file --hidden --follow --strip-cwd-prefix --exclude .git";
      defaultOptions = [
        "--height=30%"
        "--layout=reverse"
        "--info=inline"
      ];
    };

    # neofetch --> hyfetch
    hyfetch = {
      enable = true;

      settings = {
        mode = "rgb";
        preset = "transgender";
        light_dark = "dark";
        lightness = 0.6;
        colour_align = {
          mode = "horizontal";
        };
        backend = "neofetch";
      };
    };

    # grep --> rg
    ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--max-columns=150"
        "--max-columns-preview"
        "--glob=!.git/*"
        "--smart-case"
      ];
    };

    # cd --> z
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
