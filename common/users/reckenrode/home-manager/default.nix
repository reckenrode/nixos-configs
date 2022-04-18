{ pkgs, ... }:

let
  inherit (pkgs) neovim ripgrep;
in
{
  home.packages = [
    neovim
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR = "${neovim}/bin/nvim";
  };

  programs.fish.enable = true;
}
