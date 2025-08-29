{config, ...}: {
  # TLDR:
  #
  # iwd              - wireless
  # networkd         - dhcp
  # NetworkManager   - devices
  # systemd-resolved - dns
  #
  # https://tailscale.com/blog/sisyphean-dns-client-linux
  networking = {
    # generate hostId by hashing hostname
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # use networkd instead of global dhcp
    useDHCP = false;
    useNetworkd = true;

    enableIPv6 = true;
  };
}
