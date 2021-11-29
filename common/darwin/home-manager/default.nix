{ pkgs, config, unstablePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./gnupg.nix
    ./keyboard.nix
    ./rust.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages =
    let
      inherit (pkgs) coreutils diffutils findutils less;
      inherit (unstablePkgs.darwin) trash;
      inherit (unstablePkgs) iterm2;
    in
    [
      coreutils
      diffutils
      findutils
      less
      trash
      iterm2
    ];

  home.stateVersion = "21.05";
}
