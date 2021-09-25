{ config, lib, pkgs, flakePkgs, ... }:

{
  home.packages = with pkgs; [
    openssh
    steam
    flakePkgs.verify-archive
  ];
}
