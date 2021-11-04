{ lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
    ./kitty.nix
    ./nix-flakes.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  nix = {
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;
}
