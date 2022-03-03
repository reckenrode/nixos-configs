{ pkgs, ... }:

let
  inherit (pkgs) neovim ripgrep;
in
{
  imports = [
    ./bash.nix
    ./gnupg.nix
    ./iterm2.nix
    ./less.nix
    ./python.nix
    ./xdg.nix
  ];

  home.packages = [
    neovim
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR = "${neovim}/bin/nvim";
  };

  programs.fish.enable = true;

  home.stateVersion = "21.11";
}
