{ lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./nix-flakes.nix
    ./users
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "finalfantasyxiv"
    "firefox-bin"
    "ruby-mine"
    "pycharm-professional"
    "pathofexile"
    "pngout"
    "steam"
    "vscode"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      finalfantasyxiv = pkgs.callPackage ../pkgs/finalfantasyxiv.nix {};
      firefox-bin = pkgs.callPackage ../pkgs/firefox-bin.nix {};
      jetbrains = prev.jetbrains // {
        ruby-mine = pkgs.callPackage ../pkgs/ruby-mine.nix {};
        pycharm-professional = pkgs.callPackage ../pkgs/pycharm-professional.nix {};
      };
      netnewswire = pkgs.callPackage ../pkgs/netnewswire.nix {};
      openttd = pkgs.callPackage ../pkgs/openttd.nix {};
      pathofexile = pkgs.callPackage ../pkgs/pathofexile.nix {};
      pngout = prev.pngout.overrideAttrs (_: rec {
        name = "pngout-20200115";
        src = builtins.fetchurl {
          url = "http://www.jonof.id.au/files/kenutils/pngout-20200115-macos.zip";
          sha256 = "sha256-MnL6lH7q/BrACG4fFJNfnvoh0JClVeaJIlX+XIj2aG4=";
        };
        nativeBuildInputs = with final; [ unzip ];
        unpackPhase = ''
          unzip "$src"
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp ${name}-macos/pngout $out/bin
          /usr/bin/codesign -fs - $out/bin/pngout
        '';
      });
      secretive = pkgs.callPackage ../pkgs/secretive.nix {};
      steam = pkgs.callPackage ../pkgs/steam.nix {};
      tiled = pkgs.callPackage ../pkgs/tiled.nix {};
      trash_mac = pkgs.callPackage ../pkgs/trash_mac {};
      waifu2x-converter-cpp = (prev.waifu2x-converter-cpp.overrideAttrs (old: rec {
        patches = [ ./files/waifu2x_darwin_build.diff ];   
        patchPhase = null;
        postPatch = old.patchPhase;
        preFixup = lib.optional prev.stdenv.isLinux old.preFixup; 
        meta = old.meta // {                                     
          platforms = old.meta.platforms ++ lib.platforms.darwin; 
        };
      })).override {                                                                           
        opencv3 = final.opencv4;
        ocl-icd = final.darwin.apple_sdk.frameworks.OpenCL;                         
        opencl-headers = final.darwin.apple_sdk.frameworks.OpenCL;   
      };
    })
  ];

  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;
}
