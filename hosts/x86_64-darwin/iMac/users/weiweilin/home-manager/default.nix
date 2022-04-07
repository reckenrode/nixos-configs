{ pkgs
, ...
}:

{
  imports = [
    ./git.nix
  ];

  home.packages = [ (pkgs.python3.withPackages (pkgs: [ pkgs.tkinter ])) ];
}
