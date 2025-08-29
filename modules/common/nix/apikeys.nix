{config, ...}: let
  inherit (config.age) secrets;
in {
  config.nix.extraOptions = ''
    !include ${secrets.gh-api.path}
  '';
}
