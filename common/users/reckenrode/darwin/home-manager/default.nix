{ pkgs, ... }:

let
  inherit (pkgs) neovim ripgrep;
in
{
  imports = [
    ./dock.nix
    ./finder.nix
    ./iterm2.nix
    ./keyboard.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages = [
    neovim
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR = "${neovim}/bin/nvim";
  };

  programs.fish.enable = true;
}
