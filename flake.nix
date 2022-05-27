{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # FIXME: switch back to a versioned branch once the fix for building on recent nix-darwin
    # lands there.
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
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
