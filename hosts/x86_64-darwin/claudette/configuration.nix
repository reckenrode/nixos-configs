{ ... }:

{
  imports = [
    ./cups
    ../../../common/darwin.nix
  ];

  networking.hostName = "claudette";
}
