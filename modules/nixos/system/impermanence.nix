{
  inputs,
  config,
  lib,
  self,
  ...
}: let
  inherit (config.garden.hardware) disks;
  cfg = config.garden.system.impermanence;
in {
  options.garden.system.impermanence = {
    enable =
      lib.mkEnableOption "Impermanence"
      // {
        default = disks.impermanence.enable;
      };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = lib.flatten[
        "/root"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"

        # acme
        (lib.optionals (config.security.acme.acceptTerms) [
          "/var/lib/acme"
        ])

        # networkmanager
        (lib.optionals (config.networking.networkmanager.enable) [
          "/etc/NetworkManager/system-connections"
        ])
      ];

      files = lib.flatten [
        "/etc/adjtime"
        "/etc/machine-id"

        # ssh keys
        (lib.optionals (config.services.openssh.enable) (
          builtins.map (x: [x.path (x.path + ".pub")]) config.services.openssh.hostKeys
        ))

        # networkmanager
        (lib.optionals (config.networking.networkmanager.enable) [
          "/var/lib/NetworkManager/secret_key"
          "/var/lib/NetworkManager/seen-bssids"
          "/var/lib/NetworkManager/timestamps"
        ])
      ];
    };
  };
}
