{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    nvd
    ripgrep
  ];

  programs.fish.enable = true;

  programs.fish.interactiveShellInit = ''
    set -x EDITOR "${pkgs.neovim}/bin/nvim";
  '';

  home.stateVersion = "21.05";
}
