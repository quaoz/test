{osConfig, ...}: let
  inherit (osConfig.age) secrets;
in {
  programs.ssh = {
    enable = true;

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
        compression = true;
        hashKnownHosts = true;
        addKeysToAgent = "yes";
      };
    };
  };
}
