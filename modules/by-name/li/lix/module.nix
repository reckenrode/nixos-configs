{ inputs, pkgs, ... }@args:

let
  pkgs = inputs.nixpkgs-unstable.legacyPackages.${args.pkgs.stdenv.hostPlatform.system};
  lixPackageSet = pkgs.lixPackageSets.lix_2_96;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (lixPackageSet)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        nil
        ;
    })
  ];

  nix.package = lixPackageSet.lix;
}
