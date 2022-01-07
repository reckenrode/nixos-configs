{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";

    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    verify-archive.url = "github:reckenrode/verify-archive/releases";
    verify-archive.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs@{ self, utils, nixpkgs, darwin, home-manager, ... }:
    let
      inherit (nixpkgs.lib) recursiveUpdate;

      overlays = import ./overlays;
      packages = import ./pkgs;
    in
    utils.lib.mkFlake rec {
      inherit self inputs;

      channels.nixpkgs = {
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "crossover"
          "daisydisk"
          "finalfantasyxiv"
          "firefox-bin"
          "foundryvtt"
          "ruby-mine"
          "pycharm-professional"
          "pathofexile"
          "pngout"
          "steam"
          "vscode"
        ];
        overlaysBuilder = channels: [ (overlays { inherit lib; }) ];
      };

      channels.nixpkgs-unstable = {
        overlaysBuilder = channels: [ (overlays { inherit lib; }) ];
      };

      hostDefaults.modules = [
        ./common/configuration.nix
      ];

      hosts = lib.mkHosts {
        inherit self channels overlays;
        hostsPath = ./hosts;
      };

      lib = import ./lib;

      outputsBuilder = channels: {
        packages =
          let
            inherit (channels.nixpkgs.stdenv.hostPlatform) system;
          in
          packages { inherit lib channels; } // {
            inherit (inputs.verify-archive.packages."${system}") verify-archive;
            inherit (inputs.foundryvtt.packages."${system}") foundryvtt;
          };
      };
    };
}
