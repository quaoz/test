{osConfig, ...}: let
  inherit (osConfig.age) secrets;
in {
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = secrets.github.path;
      };

      nix-remote = {
        match = "user nix-remote host *";
        identityFile = secrets.nix-remote.path;
      };

      "*" = {
        setEnv.TERM = "xterm-256colour";
      };
    };
  };
}
