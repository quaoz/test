{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home = lib.mkIf (osConfig.garden.profiles.desktop.enable && pkgs.stdenv.isDarwin) {
    packages = with pkgs; [
      claude
    ];

    file."Library/Application Support/Claude/claude_desktop_config.json".text = builtins.toJSON {
      mcpServers = {
        binaryninja = {
          command = "${pkgs.uv}/bin/uvx";
          args = ["binaryninja-mcp" "client"];
        };
      };

      globalShortcut = "";
    };
  };
}
