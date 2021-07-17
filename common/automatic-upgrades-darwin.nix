{ config, lib, pkgs, ... }:

{
  options.nix.automaticUpgrades.enable = lib.mkEnableOption "Enable default automatic upgrade settings";
  config = lib.mkIf config.nix.automaticUpgrades.enable {
    launchd.daemons."darwin-upgrade".serviceConfig = {
      ProgramArguments = with pkgs; [
        "/bin/sh" "-c"
        ''
          /bin/wait4path /run/current-system/sw/bin/darwin-rebuild && \
            /run/current-system/sw/bin/darwin-rebuild switch \
              --flake github:reckenrode/nixos-configs && exec rm result
        ''
      ];
      StartCalendarInterval = [
        {
          Hour = 3;
          Minute = 0;
        }
      ];
      StandardErrorPath = "/var/log/darwin-upgrade.log";
      StandardOutPath = "/var/log/darwin-upgrade.log";
    };
  };
}
