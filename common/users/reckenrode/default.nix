{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish.enable = true;

  home.stateVersion = "20.09";
}
