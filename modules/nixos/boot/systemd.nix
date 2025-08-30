{
  boot = {
    loader = {
      systemd-boot = {
        # use the systemd-boot efi boot loader.
        enable = true;

        # https://search.nixos.org/options?channel=unstable&show=boot.loader.systemd-boot.editor
        editor = false;

        # only keep last 8 generations
        configurationLimit = 8;

        # use largest available console resolution
        consoleMode = "max";
      };

      # let installation modify boot variables
      efi.canTouchEfiVariables = true;
    };

    # enable systemd in initrd
    initrd.systemd.enable = true;
  };
}
