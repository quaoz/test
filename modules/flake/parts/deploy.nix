{
  inputs,
  config,
  self,
  ...
}: {
  flake.deploy = {
    user = "root";
    sshUser = config.me.username;
    sshOpts = ["-A"];

    nodes =
      self.nixosConfigurations
      |> builtins.mapAttrs (hostname: hostconfig: let
        inherit (hostconfig.pkgs.stdenv.hostPlatform) system;
      in {
        inherit hostname;

        # don't build on slow hosts
        remoteBuild = !config.garden.profiles.slow.enable;

        profiles.system.path = inputs.deploy-rs.lib.${system}.activate.${hostconfig.class} hostconfig;
      });
  };

  flake.checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
}
