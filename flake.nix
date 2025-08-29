{
  description = "waow";

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} {imports = [./modules/flake];};

  inputs = {
    # https://deer.social/profile/did:plc:mojgntlezho4qt7uvcfkdndg/post/3loogwsoqok2w
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # cooler nix
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";

    # better darwin support
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # manage user environment with nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # user contributed packages (basically only used for rycee/firefox-addons)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # glue
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

    # secrets
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox on darwin
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: revert once apple sdk stubs removed
    # WATCH: https://github.com/serokell/deploy-rs/issues/322
    deploy-rs = {
      url = "git+file:/Users/ada/Projects/playground/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: remove once version supporting pipe-operator in nixpkgs
    deadnix = {
      url = "github:astro/deadnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: remove once https://github.com/oppiliappan/statix/pull/102 is merged
    statix = {
      url = "github:RobWalt/statix/support-pipe-operator";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
