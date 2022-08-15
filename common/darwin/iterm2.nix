{ pkgs, ... }:

let
  iterm2 = pkgs.iterm2.overrideAttrs (_: {
    dontFixup = true;
  });
in
{
  environment.systemPackages = [ iterm2 ];
}
