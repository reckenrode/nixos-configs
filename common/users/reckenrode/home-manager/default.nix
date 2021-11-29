{ pkgs, ... }:

let
  inherit (pkgs) neovim ripgrep;
in
{
  imports = [
    ./bash.nix
    ./gnupg.nix
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
}
