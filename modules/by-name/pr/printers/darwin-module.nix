# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  inherit (lib) types;

  mkPrinter = p:
    let
      iconPath = "/Library/Printers/Icons/${baseNameOf p.icon}";
    in
    lib.optionalString (p.icon != null) ''
      install -m 644 -o root -g admin '${p.icon}' '${iconPath}'
      ${lib.getBin pkgs.cups}/bin/lpadmin -p '${p.name}' -o APPrinterIconPath='${iconPath}'
    '' + lib.optionalString (p.suppliesUrl != null) ''
      ${lib.getBin pkgs.cups}/bin/lpadmin -p '${p.name}' -o APSupplies='${p.suppliesUrl}'
    '';

  cfg = config.hardware.printers;
in
{
  options.hardware.printers = lib.mkOption {
    description = "Manage PPD settings such as setting an icon or its supplies URL.";

    default = [];

    type = types.listOf (types.submodule {
      options = {
        name = lib.mkOption {
          type = types.str;
          description = "Name of the printer queue to manage.";
        };

        icon = lib.mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Sets the icon for the printer in the PPD and copies it to `/Library/Printers/Icons`.
          '';
        };

        suppliesUrl = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Sets the URL to use for checking supplies.";
        };
      };
    });
  };

  config = {
    assertions = map (p: {
      assertion = p.icon != null || p.suppliesUrl != null;
      message = "Printer “${p.name}” must set at least one of `icon` or `suppliesUrl`.";
    }) cfg;

    system.activationScripts.extraActivation.text = lib.mkIf (cfg != [ ]) (''
      echo 'setting up print queues...' >&2
    '' + lib.concatMapStringsSep "\n" mkPrinter cfg);
  };
}
