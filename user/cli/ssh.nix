{
  osConfig,
  self,
  lib,
  ...
}: let
  inherit (osConfig.age) secrets;
  inherit (osConfig.me) username;

  hosts =
    self.nixosConfigurations
    // self.darwinConfigurations
    |> lib.filterAttrs (_: v: v.config.services.openssh.enable == true)
    |> builtins.mapAttrs (n: _: {
      match = "user ${username} host ${n}";
      forwardAgent = true;
    });

  remoteBuilders = osConfig.nix.buildMachines |> builtins.map (x: x.hostName) |> builtins.concatStringsSep ",";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks =
      {
        "*" = {
          forwardAgent = false;
          addKeysToAgent =
            if osConfig.garden.profiles.desktop.enable
            then "yes"
            else "no";

          compression = true;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;

          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";

          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = secrets.github.path;
        };

        nix-remote = {
          match = "user nix-remote host \"${remoteBuilders}\"";
          identityFile = secrets.nix-remote.path;
        };
      }
      // hosts;
  };
}
