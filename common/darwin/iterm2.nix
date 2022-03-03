{ pkgs, unstablePkgs, ... }:

{
  environment.systemPackages =
    let
      iterm2 = pkgs.callPackage unstablePkgs.iterm2.override { };
    in
    [
      iterm2
    ];
}
