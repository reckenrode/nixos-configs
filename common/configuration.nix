{ lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
    ./kitty.nix
    ./nix-flakes.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  programs.fish.enable = true;
}
