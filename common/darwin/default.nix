{ lib, pkgs, ... }:

{
  imports = [
    ./nix-optimizations-darwin.nix
  ];

  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;
}
