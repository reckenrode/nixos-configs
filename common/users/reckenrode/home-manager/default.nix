{ pkgs, ... }:

let
  inherit (pkgs) neovim ripgrep;
in
{
  imports = [
    ./bash.nix
    ./dock.nix
    ./finder.nix
    ./gnupg.nix
    ./gnupg.nix
    ./iterm2.nix
    ./keyboard.nix
    ./less.nix
    ./python.nix
    ./safari.nix
    ./ui.nix
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
