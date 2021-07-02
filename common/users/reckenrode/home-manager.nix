{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish.enable = true;

  home.stateVersion = "21.05";
}
