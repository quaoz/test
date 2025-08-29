{lib, ...}: let
  /**
  recursively list all nix files in a directory, if given a file instead of a
  directory it will return a list of nix files in the same directory as the
  file excluding the file

  # Inputs

  `p`
  : the path to list

  # Type

  ```nix
  nixFiles :: Path --> [ Path ]
  ```

  # Example

  ```nix
  nixFiles ./.
  => [ ./flake.nix ./nix/other.nix ]
  ```
  */
  nixFiles = p:
    if builtins.readFileType p == "directory"
    then nixFiles' p []
    else nixFiles' (builtins.dirOf p) [p];

  /**
  recursively list all nix files in a directory excluding the specified path(s)

  # Inputs

  `p`
  : the path to list

  # Type

  ```nix
  nixFiles :: Path --> [ Path ] --> [ Path ]
  ```

  # Example

  ```nix
  nixFiles' ./. [ ./nix/other.nix ]
  => [ ./flake.nix ]
  ```
  */
  nixFiles' = p: excludes:
    lib.filesystem.listFilesRecursive p
    |> builtins.filter (f: lib.hasSuffix ".nix" f && builtins.all (e: !lib.path.hasPrefix e f) excludes);

  /**
  imports a nix file automatically providing the necessary inputs

  # Inputs

  `inputs`
  : the inputs to be made available to the file

  `path`
  : the file to import

  # Type

  ```nix
  autoImport :: Path --> {}
  ```

  # Example

  ```nix
  autoImport ./default.nix
  => {...}
  ```
  */
  autoImport = inputs: path: let
    f = lib.toFunction (import path);
  in
    f
    |> lib.functionArgs
    |> builtins.mapAttrs (n: _: inputs.${n})
    |> f;

  /**
  recursively imports and merges all nix files in a directory

  # Inputs

  `inputs`
  : the inputs to be made available to the files

  `dir`
  : the directory to import

  # Type

  ```nix
  harvest :: Path --> {}
  ```

  # Example

  ```nix
  harvest ./.
  => {...}
  ```
  */
  harvest = inputs: dir:
    nixFiles dir
    |> builtins.map (autoImport inputs)
    |> builtins.foldl' lib.recursiveUpdate {};
in {
  # the only place harvest (and autoImport) are used is when loading the lib (../default.nix)
  inherit nixFiles nixFiles' autoImport harvest;
}
