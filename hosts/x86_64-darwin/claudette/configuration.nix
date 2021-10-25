{ ... }:

{
  imports = [
    ./cups
    ./keybase.nix
  ];

  networking.hostName = "claudette";
}
