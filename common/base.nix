{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.git ];
}
