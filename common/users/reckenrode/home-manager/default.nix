{ pkgs, unstablePkgs, ... }:

let
  inherit (pkgs) ripgrep;
  inherit (unstablePkgs) neovim;
in
{
  imports = [
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
