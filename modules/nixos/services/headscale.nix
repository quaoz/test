{
  lib,
  self,
  config,
  ...
}: let
  cfg = config.garden.services.headscale;
in {
  options.garden.services.headscale = self.lib.mkServiceOpt "headscale" {
    port = 3757;
    host = "0.0.0.0";
    domain = "hs.${config.garden.domain}";
  };

  config = lib.mkIf cfg.enable {
    # open firewall
    networking.firewall.allowedUDPPorts = [cfg.port];

    services = {
      headscale = {
        enable = true;
        address = cfg.host;
        inherit (cfg) port;

        settings = {
          server_url = "https://${cfg.domain}";

          dns = {
            base_domain = "internal.${config.garden.domain}";
            # TODO: use blocky
            nameservers.global = ["9.9.9.9"];
          };

          logtail.enabled = false;
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = false;
        useACMEHost = config.garden.domain;

        locations."/" = {
          proxyPass = "http://${cfg.host}:${builtins.toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
