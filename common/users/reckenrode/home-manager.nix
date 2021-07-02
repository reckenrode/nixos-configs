{ pkgs, ... }:

{
  home.packages = with pkgs; [
    coreutils
    neovim
    ripgrep
    trash_mac
  ];

  programs.fish.enable = true;

  home.stateVersion = "20.09";
}
