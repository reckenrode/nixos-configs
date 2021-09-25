{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.0";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    verify-archive.url = "github:reckenrode/verify-archive";
    verify-archive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, utils, nixpkgs, darwin, home-manager, ... }:
    let
      inherit (import ./lib) mkHosts;

      overlays = import ./overlays;
      packages = import ./pkgs;
    in
    utils.lib.mkFlake rec {
      inherit self inputs;

      channels.nixpkgs = {
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "crossover"
          "finalfantasyxiv"
          "firefox-bin"
          "ruby-mine"
          "pycharm-professional"
          "pathofexile"
          "pngout"
          "steam"
          "vscode"
        ];
        overlaysBuilder = channels: [ overlays ];
      };

      hostDefaults.modules = [
        ./common
      ];
      hosts = mkHosts self ./hosts;
      
      outputsBuilder = channels: {
        packages = packages channels.nixpkgs // {
          verify-archive = inputs.verify-archive.packages.${channels.nixpkgs.system}.verify-archive;
        };
      };
    };
}
