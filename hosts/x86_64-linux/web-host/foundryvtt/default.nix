{ config, ... }:

{
  imports = [
    ./coturn.nix
    ./foundryvtt.nix
  ];
}
