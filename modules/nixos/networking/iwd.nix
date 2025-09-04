{
  lib,
  config,
  ...
}: let
  cfg = config.garden.system.networking.wireless;
in {
  options.garden.system.networking.wireless.enable =
    lib.mkEnableOption "Wireless networking"
    // {
      default = true;
    };

  config = {
    # enable wireless database
    hardware.wirelessRegulatoryDatabase = cfg.enable;

    networking = {
      # use iwd as the wifi backend
      networkmanager.wifi.backend = "iwd";

      wireless = {
        # disable wpa_supplicant
        enable = false;

        # use iwd instead
        iwd = {
          inherit (cfg) enable;

          # https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/iwd.network.rst
          # https://www.mankier.com/5/iwd.config
          settings = {
            Settings = {
              # autoconnect to networks
              AutoConnect = true;
            };

            General = {
              # randomize full mac address on each connection
              AddressRandomization = "network";
              AddressRandomizationRange = "full";

              # let iwd configure network interfaces
              EnableNetworkConfiguration = true;
            };

            Network = {
              # enable ipv6
              EnableIPv6 = true;
            };
          };
        };
      };
    };
  };
}
