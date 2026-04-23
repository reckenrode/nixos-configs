{ inputs, pkgs, ... }@args:

let
  pkgs = inputs.nixpkgs-unstable.legacyPackages.${args.pkgs.stdenv.hostPlatform.system};
in
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (pkgs.lixPackageSets.latest)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        nil
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.latest.lix;
}
