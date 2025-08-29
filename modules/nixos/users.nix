{config, ...}: let
  inherit (config.me) username;

  ifGroupsExist = builtins.filter (g: builtins.hasAttr g config.users.groups);
in {
  config.users.users.${username} = {
    name = username;
    uid = 1000;

    home = "/home/${username}";
    shell = "/run/current-system/sw/bin/bash";

    isNormalUser = true;
    isSystemUser = false;

    extraGroups =
      [
        "wheel"
      ]
      ++ ifGroupsExist [
        "networkmanager"
      ];
  };
}
