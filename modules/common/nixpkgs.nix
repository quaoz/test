{
  lib,
  self,
  inputs,
  ...
}: {
  config.nixpkgs = {
    config = {
      # don't allow aliases bcos it can get messy
      allowAliases = false;

      # explicately allow some unfree software
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "broadcom-sta"
          "claude-desktop"
          "discord"
          "discord-canary"
          "faststream"
          "minecraft-server"
          "keka"
          "obsidian"
          "raycast"
        ];
    };

    overlays = [
      inputs.lix-module.overlays.default
      inputs.nur.overlays.default
      inputs.nixpkgs-firefox-darwin.overlay

      self.overlays.default
    ];
  };
}
