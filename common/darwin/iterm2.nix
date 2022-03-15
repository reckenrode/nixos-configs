{ pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = [ unstablePkgs.iterm2 ];
}
