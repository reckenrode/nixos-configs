{ ... }:

{
  imports = [
    ./bash.nix
    ./dotnet.nix
    ./gnupg.nix
    ./less.nix
    ./python.nix
    ./xdg.nix
  ];

  home.stateVersion = "21.11";
}
