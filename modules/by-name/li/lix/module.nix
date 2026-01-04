{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (pkgs.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
