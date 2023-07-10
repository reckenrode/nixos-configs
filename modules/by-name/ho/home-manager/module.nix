# SPDX-License-Identifier: MIT

{ lib, options, ... }:

{
 config = lib.optionalAttrs (lib.hasAttr "home-manager" options) {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
