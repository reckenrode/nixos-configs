{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -x EDITOR "${pkgs.neovim}/bin/nvim";
    '';
  };

  home.stateVersion = "21.05";
}
