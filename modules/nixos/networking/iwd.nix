{
  # enable wireless database
  hardware.wirelessRegulatoryDatabase = true;

  networking = {
    # use iwd as the wifi backend
    networkmanager.wifi.backend = "iwd";

    wireless = {
      # disable wpa_supplicant
      enable = false;

      # use iwd instead
      iwd = {
        enable = true;

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
}
