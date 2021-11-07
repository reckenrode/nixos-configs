{ ... }:

{
  nix.extraOptions = "extra-platforms = armv7l-linux";
  nix.binaryCaches = [ "https://app.cachix.org/cache/thefloweringash-armv7" ];
  nix.binaryCachePublicKeys = [ "thefloweringash-armv7.cachix.org-1:v+5yzBD2odFKeXbmC+OPWVqx4WVoIVO6UXgnSAWFtso=" ];
}
