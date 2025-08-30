{
  self,
  pkgs,
  config,
  ...
}: let
  inherit (config.me) username pubkey;
  inherit (config.networking) hostName;

  group = self.lib.ldTernary pkgs "wheel" "admin";
  secretDir = ../../secrets;
in {
  config.age =
    {
      rekey = {
        storageMode = "local";
        localStorageDir = secretDir + "/rekeyed/${hostName}";

        hostPubkey = config.garden.pubkey;
        masterIdentities = [
          {
            identity = "/Users/${username}/.ssh/id_ed25519";
            inherit pubkey;
          }
        ];
      };

      identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/home/${username}/.ssh/id_ed25519"
        "/Users/${username}/.ssh/id_ed25519"
      ];

      secrets = {
        gh-api = {
          rekeyFile = secretDir + "/gh-api.age";
        };

        cloudflare-cert-api = {
          rekeyFile = secretDir + "/cloudflare-cert-api.age";
        };

        tailscale-key = {
          rekeyFile = secretDir + "/tailscale-key.age";
        };

        nix-signing-key = {
          rekeyFile = secretDir + "/nix/nix-signing-key.age";
        };

        nix-signing-key-pub = {
          rekeyFile = secretDir + "/nix/nix-signing-key-pub.age";
        };

        password = {
          rekeyFile = secretDir + "/password.age";
          owner = username;
          inherit group;
        };

        github = {
          rekeyFile = secretDir + "/ssh/github.age";
          owner = username;
          inherit group;
        };

        github-pub = {
          rekeyFile = secretDir + "/ssh/github-pub.age";
          owner = username;
          inherit group;
        };

        nix-remote = {
          rekeyFile = secretDir + "/ssh/nix-remote.age";
          owner = username;
          inherit group;
        };

        nix-remote-pub = {
          rekeyFile = secretDir + "/ssh/nix-remote-pub.age";
          owner = username;
          inherit group;
        };
      };
    }
    // self.lib.onlyDarwin pkgs {
      # use an actual directory
      secretsDir = "/private/tmp/agenix";
      secretsMountPoint = "/private/tmp/agenix.d";
    };
}
