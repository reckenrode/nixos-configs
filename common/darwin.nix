{ lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./nix-flakes.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "pngout"
    "vscode"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      pngout = prev.pngout.overrideAttrs (_: rec {
        name = "pngout-20200115";
        src = builtins.fetchurl {
          url = "http://www.jonof.id.au/files/kenutils/pngout-20200115-macos.zip";
          sha256 = "0vk8ys45rzjm4a4ycmd5j3823ylyby9i87vf1301mz7agsaglwij";
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
      trash_mac = pkgs.unstable.callPackage ../pkgs/trash_mac {};
      waifu2x-converter-cpp = (pkgs.unstable.waifu2x-converter-cpp.overrideAttrs (old: rec {
        patches = [ ./files/waifu2x_darwin_build.diff ];   
        patchPhase = null;
        postPatch = old.patchPhase;
        preFixup = lib.optional (!pkgs.stdenv.isDarwin) old.preFixup; 
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

  programs.fish = lib.optionalAttrs (lib.hasAttr "babelfish" pkgs) {
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;
}
