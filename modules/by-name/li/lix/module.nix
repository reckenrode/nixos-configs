{ inputs, pkgs, ... }:

let
  # Work around bug in c-ares without rebuilding everything just for Lix.
  # See: https://github.com/NixOS/nixpkgs/pull/462151
  nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  lixPackageSets.stable = nixpkgs-unstable.lixPackageSets.stable.overrideScope (final: prev: {
    lix = prev.lix.override {
      curl = nixpkgs-unstable.curl.override {
        c-aresMinimal = inputs.lix-fixed.legacyPackages.${pkgs.system}.c-aresMinimal.override {
          inherit (nixpkgs-unstable) cmake stdenv updateAutotoolsGnuConfigScriptsHook;
        };
      };
    };
  });
in
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = lixPackageSets.stable.lix;
}
