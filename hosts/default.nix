{
  lib,
  self,
  inputs,
  ...
}: let
  additionalClasses = {
    rpi = "nixos";
  };

  resolveClass = class: additionalClasses.${class} or class;
in {
  imports = [
    inputs.easy-hosts.flakeModule
    inputs.agenix-rekey.flakeModule
  ];

  config.easy-hosts = {
    inherit additionalClasses;

    shared.modules = [
      ../modules/flake/options.nix
    ];

    perClass = rawClass: let
      class = resolveClass rawClass;
    in {
      modules = builtins.concatLists [
        (self.lib.nixFiles ../modules/${class})

        (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.agenix-rekey.nixosModules.default
          inputs.ragenix.nixosModules.default
        ])

        (lib.optionals (class == "darwin") [
          inputs.home-manager.darwinModules.home-manager
          inputs.stylix.darwinModules.stylix
          inputs.agenix-rekey.nixosModules.default
          inputs.ragenix.darwinModules.default
        ])
      ];
    };

    hosts = {
      # keep-sorted start block=yes newline_separated=yes
      blume = {
        class = "iso";
      };

      ganymede = {
        arch = "x86_64";
        class = "nixos";
      };

      nyx = {
        arch = "aarch64";
        class = "darwin";
      };

      verenia = {
        arch = "x86_64";
        class = "nixos";
      };
      # keep-sorted end
    };
  };
}
