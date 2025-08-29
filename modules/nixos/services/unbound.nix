{
  lib,
  self,
  config,
  ...
}: let
  cfg = config.garden.services.unbound;
in {
  options.garden.services.unbound = self.lib.mkServiceOpt "unbound" {
    port = 5335;
  };

  # unbound is configured to be used in combination with blocky (or something similar)
  # TODO: maybe further limit memory usage
  #       https://www.mankier.com/5/unbound.conf#Memory_Control_Example
  config = lib.mkIf cfg.enable {
    services.unbound = {
      enable = true;

      # https://www.mankier.com/5/unbound.conf
      settings = {
        server = {
          # set interface and port
          access-control = ["127.0.0.1 allow"];
          interface = [cfg.host];
          inherit (cfg) port;

          # deny queries of type ANY with an empty response
          deny-any = true;

          # harden against algorithm downgrade when multiple algorithms are advertised in the DS record
          harden-algo-downgrade = true;
          # ignore very large queries
          harden-large-queries = true;

          # prefetch cached elements before they expire
          prefetch = true;

          # very short lived cache as blocky also provides cachine
          cache-max-ttl = 60;
          cache-max-negative-ttl = 60;

          # ensure blocky receives the original ttl
          serve-original-ttl = true;
        };
      };
    };
  };
}
