{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish.enable = true;

  programs.fish.interactiveShellInit = ''
    set -x EDITOR "${pkgs.neovim}/bin/nvim";
  '';

  home.stateVersion = "21.05";
}
