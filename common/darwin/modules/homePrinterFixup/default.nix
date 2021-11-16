{ config, lib, pkgs, ... }:

let
  ppd = ./files/HP_Color_LaserJet_Pro_M454dw.ppd;
  ppdIcon = ./files/M453dw.icns;
in {
  options.system.homePrinterFixup = lib.mkEnableOption "Augment the CUPS printer settings";
  config = lib.mkIf config.system.homePrinterFixup {
    system.activationScripts.extraActivation.text = ''
      ppdFile="/etc/cups/ppd/HP_Color_LaserJet_Pro_M454dw.ppd"
      iconFile="/Library/Printers/Icons/M453dw.icns"
      $DRY_RUN_CMD ${pkgs.gnused}/bin/sed -Ez '
        s|(\*cupsIdentifyActions: "display").*(\*APAcceptsMixedURF: True)|\1\n*APPrinterIconPath: "/Library/Printers/Icons/M453dw.icns"\n\2|
        s|\*APSupplies: "[^"]*"|*APSupplies: "https://jihli.infra.largeandhighquality.com/#hId-pgConsumables"|
      ' -i "$ppdFile" 2> /dev/null || true
      $DRY_RUN_CMD install -m 644 -o root -g admin "${ppdIcon}" "$iconFile"
    '';
  };
}
