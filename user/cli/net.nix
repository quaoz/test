{pkgs, ...}: {
  # various networking tools
  home.packages = with pkgs; [
    # dns
    dnsutils
    doggo

    # downloads
    aria2
    wget

    # requests
    curl
    xh

    # network scanner
    nmap

    # network load monitors
    bandwhich

    # network sniffers
    tcpdump
    termshark

    # misc
    inetutils
    iperf
    whois
  ];
}
