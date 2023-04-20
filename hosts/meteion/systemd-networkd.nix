# SPDX-License-Identifier: MIT

{ lib, pkgs, inputs, ... }:

{
  # FIXME: Switch to the stable package once 23.05 is released.
  networking.wireless.iwd.package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.iwd;

  systemd.network.networks.wlan = {
    enable = true;
    matchConfig.Type = "wlan";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
