{ pkgs, ... }:

{
  imports = [
    ./fish.nix
  ];

  home.packages = with pkgs; [
    neovim
    ripgrep
  ];
}
