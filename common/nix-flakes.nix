{ lib, unstablePkgs, ... }:

{
  nix.package = unstablePkgs.nix;
}
