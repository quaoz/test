{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.services.tailscale) package;

  authKeyFile = config.age.secrets.tailscale-key.path;
in {
  services.tailscale = {
    enable = true;
  };

  environment.systemPackages = [
    package
  ];

  # automatically authorise machine
  # https://github.com/NixOS/nixpkgs/blob/33e1f9420067659c188dc8a34b8ec2110d28f8c0/nixos/modules/services/networking/tailscale.nix#L172-L200
  launchd.daemons.tailscaled-autoconnect = {
    serviceConfig = {
      Label = "com.tailscale.tailscaled-autoconnect";
      RunAtLoad = true;
    };

    script = let
      statusCommand = "${lib.getExe package} status --json --peers=false | ${lib.getExe pkgs.jq} -r '.BackendState'";
    in ''
      while [[ "$(${statusCommand})" == "NoState" ]]; do
        sleep 0.5
      done

      status=$(${statusCommand})

      if [[ "$status" == "NeedsLogin" || "$status" == "NeedsMachineAuth" ]]; then
        ${lib.getExe package} up --auth-key "$(cat ${authKeyFile})"
      fi
    '';
  };
}
