{ lib, unstablePkgs, ... }:

{
  nix.package = unstablePkgs.nixStable;
}
