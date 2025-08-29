{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  zed-exe = lib.getExe config.programs.zed-editor.package;
in {
  config = lib.mkIf osConfig.garden.profiles.desktop.enable {
    # use zed as the default editor
    home.sessionVariables.EDITOR = "${zed-exe} --wait";

    programs.zed-editor = {
      enable = true;

      extensions = [
        "assembly"
        "basher"
        "docker-compose"
        "git-firefly"
        "haskell"
        "html"
        "just"
        "just-ls"
        "log"
        "make"
        "nix"
        "scss"
        "toml"
        "wakatime"
      ];

      extraPackages = with pkgs; [
        alejandra
        shellcheck
        shfmt
      ];

      userKeymaps = [
        {
          context = "Workspace";
          bindings = {
            "shift shift" = "file_finder::Toggle";
          };
        }
        {
          # Save on entering vim normal mode, should be mapped to workspace::Save and
          # vim::NormalBefore but this can't be done at the moment (cmd-s and ctrl-c
          # map to these two actions respectively).
          #
          # See: https://github.com/zed-industries/zed/issues/7274
          context = "Editor && vim_mode == insert && !menu";
          bindings = {
            escape = [
              "workspace::SendKeystrokes"
              "cmd-s ctrl-c"
            ];
          };
        }
      ];

      # https://zed.dev/docs/configuring-zed
      userSettings = {
        # save when switching tab
        autosave = "on_focus_change";

        # don't try and update
        auto_update = false;

        minimap = {
          show = "auto";
          thumb = "always";
          thumb_border = "left_open";
        };

        lsp = {
          nil = {
            initialisation_options = {
              # use alejandra to format nix
              formatting = {
                command = ["${lib.getExe pkgs.alejandra}" "--quiet" "--"];
              };
            };
          };
        };

        languages = {
          python = {
            # https://docs.astral.sh/ruff/editors/setup/#zed
            language_servers = [
              "ruff"
            ];
            format_on_save = "on";
            formatter = [
              {
                code_actions = {
                  "source.organiseImports.ruff" = true;
                  "source.fixAll.ruff" = true;
                };
              }
              {
                language_server.name = "ruff";
              }
            ];
          };
          javascript = {
            tab_size = 4;
          };
        };

        # show line at 80 characters
        wrap_guides = [80];

        # disable telemetry
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        # always use relative line numbers
        relative_line_numbers = true;

        # show tab file icons
        tabs = {
          file_icons = true;
        };

        buffer_font_size = lib.mkForce 14;
        ui_font_size = lib.mkForce 14;

        terminal = {
          env = {
            EDITOR = "${zed-exe} --wait";
          };
        };

        vim_mode = true;
      };
    };
  };
}
