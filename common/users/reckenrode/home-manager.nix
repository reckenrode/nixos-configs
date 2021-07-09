{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  programs.fish.enable = true;

  home.stateVersion = "21.05";
}
