{ pkgs, unstablePkgs, ... }:

let
  inherit (pkgs) ripgrep;
  inherit (unstablePkgs) neovim;
in
{
  imports = [
    ./gnupg.nix
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
