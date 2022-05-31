{ lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
    ./nix-flakes.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  nix = {
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  programs.fish.enable = true;
}
