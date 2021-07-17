{ config, lib, pkgs, ... }:

{
  launchd.daemons."nix-collect-garbage".serviceConfig = {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${config.nix.package}/bin/nix-collect-garbage && \
          exec ${config.nix.package}/bin/nix-collect-garbage --delete-older-than 30d
      ''
    ];
    StartCalendarInterval = [
      {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      }
    ];
    StandardErrorPath = "/var/log/nix-store.log";
    StandardOutPath = "/var/log/nix-store.log";
  };
  # While it’s possible to set `auto-optimise-store` in `nix.conf`, it sometimes causes problems
  # on Darwin.  Run a job periodically to optimise the store.
  launchd.daemons."nix-store-optimise".serviceConfig = {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${config.nix.package}/bin/nix && \
          exec ${config.nix.package}/bin/nix store optimise
      ''
    ];
    StartCalendarInterval = [
      {
        Hour = 2;
        Minute = 30;
      }
    ];
    StandardErrorPath = "/var/log/nix-store.log";
    StandardOutPath = "/var/log/nix-store.log";
  };
}
