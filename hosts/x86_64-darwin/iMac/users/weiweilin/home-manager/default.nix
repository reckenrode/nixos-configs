{ pkgs
, ...
}:

{
  imports = [
    ./git.nix
  ];

  home.packages = [ pkgs.python3 ];
}
