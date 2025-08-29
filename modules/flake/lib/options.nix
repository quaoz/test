{lib, ...}: rec {
  /**
  create a nixos module option

  # Inputs

  `type`
  : the option type

  `default`
  : the default value when no definition is provided

  `description`
  : the option description

  # Type

  ```nix
  mkOpt :: Type --> Any --> String --> AttrSet
  ```

  # Example

  ```nix
  mkOpt types.str "default" "option description"
  ```
  */
  mkOpt = type: default: description:
    lib.mkOption {inherit type default description;};

  /**
  create a nixos module option

  # Inputs

  `type`
  : the option type

  `description`
  : the option description

  # Type

  ```nix
  mkOpt' :: Type --> String --> AttrSet
  ```

  # Example

  ```nix
  mkOpt' types.str "option description"
  ```
  */
  mkOpt' = type: description:
    lib.mkOption {inherit type description;};

  /**
  helper to quickly describe a service

  # Inputs

  `name`
  : the services name

  # Type

  ```nix
  mkServiceOpt :: String -> (Bool --> Int -> String -> String -> AttrSet) -> AttrSet
  ```

  # Example

  ```nix
  mkServiceOpt "service" { port = 3000; }
  ```
  */
  mkServiceOpt = name: {
    enable ? false,
    port ? null,
    host ? "127.0.0.1",
    domain ? null,
    extraConfig ? {},
  }:
    with lib.types;
      {
        enable = mkOpt bool enable "Enable the ${name} service";
        port = mkOpt (nullOr int) port "The port for ${name} service";
        host = mkOpt (nullOr str) host "The host for ${name} service";
        domain = mkOpt (nullOr str) domain "Domain name for the ${name} service";
      }
      // extraConfig;
}
