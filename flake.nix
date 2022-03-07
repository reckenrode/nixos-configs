{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    ffxiv.url = "github:reckenrode/nixpkgs/ffxiv";

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
    verify-archive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, utils, nixpkgs, darwin, home-manager, ... }:
    let
      inherit (nixpkgs.lib) recursiveUpdate;

      lib = import ./lib;
      overlays = import ./overlays { inherit lib; };
      packages = import ./pkgs;
    in
    utils.lib.mkFlake rec {
      inherit self inputs lib;

      channelsConfig.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "crossover"
        "daisydisk"
        "dungeondraft"
        "wonderdraft"
        "ffxiv"
        "ffxiv-client"
        "firefox-bin"
        "foundryvtt"
        "ruby-mine"
        "pycharm-professional"
        "pathofexile"
        "pngout"
        "steam"
        "vscode"
      ];

      sharedOverlays = [ overlays ];

      channels.nixpkgs-unstable = {
        overlaysBuilder = channels: [
          (_: _: { inherit (channels.ffxiv) ffxiv; })
        ];
      };

      hostDefaults.modules = [
        ./common/configuration.nix
      ];

      hosts = lib.mkHosts {
        inherit self;
        hostsPath = ./hosts;
      };

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
