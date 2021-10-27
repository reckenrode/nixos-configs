{ pkgs, ... }:
let
  ppd = ./files/HP_Color_LaserJet_Pro_M454dw.ppd;
  ppdIcon = ./files/M453dw.icns;
in {
  system.activationScripts.extraActivation.text = ''
    ppdFile="/etc/cups/ppd/HP_Color_LaserJet_Pro_M454dw.ppd"
    iconFile="/Library/Printers/Icons/M453dw.icns"
    $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "${ppd}" "$ppdFile"
    $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "${ppdIcon}" "$iconFile"
    $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} 0644 "$ppdFile"
    $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} 0644 "$iconFile"
  '';
}
