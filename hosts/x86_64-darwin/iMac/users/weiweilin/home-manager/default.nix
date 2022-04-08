{ pkgs
, ...
}:

{
  imports = [
    ./git.nix
  ];

  home.packages =
    let
      inherit (pkgs) poetry python3;
    in
    [
      poetry
      (python3.withPackages (pkgs: [ pkgs.tkinter ]))
    ];
}
