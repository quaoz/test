{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.age) secrets;
in {
  config = {
    networking.firewall = {
      # allow tailscale UDP port through firewall
      allowedUDPPorts = [config.services.tailscale.port];

      # strict filtering breaks tailscale exit node
      checkReversePath = "loose";

      # trust tailscale interface
      trustedInterfaces = ["${config.services.tailscale.interfaceName}"];
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.tailscale = {
      enable = true;

      authKeyFile = secrets.tailscale-key.path;

      extraUpFlags = lib.optionals config.garden.profiles.server.enable ["--advertise-exit-node"];
      useRoutingFeatures =
        if config.garden.profiles.server.enable
        then "server"
        else "client";
    };
  };
}
