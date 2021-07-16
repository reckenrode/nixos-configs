{ config, lib, ... }:

{
  options.nix.automaticUpgrades.enable = lib.mkEnableOption "Enable default automatic upgrade settings";
  config = lib.mkIf config.nix.automaticUpgrades.enable {
    system.autoUpgrade = {
      enable = true;
      allowReboot = true;
      dates = "03:00";
      flake = "github:reckenrode/nixos-configs";
    };
  };
}
