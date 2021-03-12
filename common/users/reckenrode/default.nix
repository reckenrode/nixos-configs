{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish.enable = true;
}
