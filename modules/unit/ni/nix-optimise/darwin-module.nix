# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  cfg = config.nix.optimise.automatic;
in
{
  options.nix.optimise.automatic = lib.mkEnableOption "Work around NixOS/nix#7273";

  config = lib.mkIf (pkgs.stdenv.isDarwin && cfg) {
    launchd.daemons."nix-store-optimise".serviceConfig = {
      ProgramArguments = [ "${lib.getBin config.nix.package}/bin/nix" "store" "optimise" ];
      StartCalendarInterval = [ { Hour = 2; Minute = 30; } ];
      StandardErrorPath = "/var/log/nix-store.log";
      StandardOutPath = "/var/log/nix-store.log";
    };
  };
}
