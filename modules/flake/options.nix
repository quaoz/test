{lib, ...}: let
  inherit (lib) mkEnableOption types;
  inherit (import ./lib/options.nix {inherit lib;}) mkOpt';
in {
  options = {
    me = {
      username = mkOpt' types.str "The username";
      pubkey = mkOpt' types.str "The ssh pubkey";
      email = mkOpt' types.str "The email";
    };

    garden = {
      pubkey = mkOpt' types.str "This hosts pubkey";

      domain = mkOpt' types.str "The domain";

      profiles = {
        server.enable = mkEnableOption "Server";
        desktop.enable = mkEnableOption "Desktop";

        slow.enable = mkEnableOption "Slow";
      };

      # hardware configuration, see: modules/nixos/hardware
      hardware = {};

      # services, see: modules/{nixos,darwin}/services
      services = {};

      system = {
        # networking configuration, see modules/nixos/networking
        networking = {};
      };
    };
  };

  config = {
    me = {
      username = "ada";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6AibH20CO2t0ClO90mELkyEM9cCXUeUYKpZv80v6n0";
    };

    garden = {
      domain = "xenia.dog";
    };
  };
}
