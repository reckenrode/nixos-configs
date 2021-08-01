{ ... }:

{
  imports = [
    ../../../common/darwin.nix
    ../../../common/cups
  ];

  networking.hostName = "claudette";
}
