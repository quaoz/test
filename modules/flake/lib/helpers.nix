let
  typeDefaults = {
    string = "";
    set = {};
    list = [];
  };

  /**
  ldTernary, short for linux darwin ternary

  # Inputs

  `pkgs`
  : the package set

  `l`
  : the value to return if the host platform is linux

  `d`
  : the value to return if the host platform is darwin

  # Type

  ```nix
  ldTernary :: AttrSet -> Any -> Any -> Any
  ```

  # Example

  ```nix
  ldTernary pkgs "linux" "darwin"
  => "linux"
  ```
  */
  ldTernary = pkgs: l: d:
    if pkgs.stdenv.hostPlatform.isLinux
    then l
    else if pkgs.stdenv.hostPlatform.isDarwin
    then d
    else throw "Unsupported system: ${pkgs.stdenv.system}";

  /**
  returns the given value if the host platform is darwin

  # Inputs

  `pkgs`
  : the package set

  `as`
  : the value to return

  # Type

  ```nix
  onlyDarwin :: AttrSet -> Any -> Any
  ```

  # Example

  ```nix
  onlyDarwin pkgs "darwin"
  => "darwin"
  ```
  */
  onlyDarwin = pkgs: as:
    if pkgs.stdenv.hostPlatform.isDarwin
    then as
    else typeDefaults."${builtins.typeOf as}" or null;

  /**
  returns the given value if the host platform is linux

  # Inputs

  `pkgs`
  : the package set

  `as`
  : the value to return

  # Type

  ```nix
  onlyLinux :: AttrSet -> Any -> Any
  ```

  # Example

  ```nix
  onlyLinux pkgs "linux"
  => "linux"
  ```
  */
  onlyLinux = pkgs: as:
    if pkgs.stdenv.hostPlatform.isLinux
    then as
    else typeDefaults."${builtins.typeOf as}" or null;

  /**
  determines if a program is enabled in the configuration

  # Inputs

  `config`
  : the configuration

  `program`
  : the program to check

  # Type

  ```nix
  isEnabled :: AttrSet -> String -> Bool
  ```

  # Example

  ```nix
  isEnabled config "bat"
  => true
  ```
  */
  isEnabled = config: program:
    builtins.hasAttr program config.programs && config.programs.${program}.enable;
in {
  inherit ldTernary isEnabled onlyDarwin onlyLinux;
}
