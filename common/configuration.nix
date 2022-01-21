{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./home-manager.nix
    ./nix-flakes.nix
  ];

  environment.systemPackages =
    let
      inherit (pkgs) git;
      pijul = pkgs.callPackage unstablePkgs.pijul.override {};
    in
    [ git pijul ];

  nix = {
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;
}
