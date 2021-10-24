{ unstablePkgs, ... }:

{
  nix.package = unstablePkgs.nix_2_4;
  nix.extraOptions = "experimental-features = nix-command flakes";
}
