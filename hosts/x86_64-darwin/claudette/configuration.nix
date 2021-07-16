{ ... }:

{
  imports = [
    ./cups
    ../../../common/darwin.nix
  ];

  networking.hostName = "claudette";

  nix.automaticUpgrades.enable = true;
}
