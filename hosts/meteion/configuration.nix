# SPDX-License-Identifier: MIT

{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./file-server.nix
    ./jellyfin-server.nix
    ./samba.nix
    ./systemd-networkd.nix
  ];

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  home-manager.users.reckenrode = inputs.self.hmModules.server-admin;

  networking.hostName = "meteion";
  networking.hostId = "41b9e6d1";

  networking.nftables.enable = true;

  networking.wireless.iwd.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      max-jobs = 3;
      trusted-users = [ "builder" ];
    };

    optimise.automatic = true;

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;

  services.mysql = {
    enable = true;
    ensureDatabases = [ "practice" ];
    package = pkgs.mariadb;
    settings.mysqld = {
      plugin-load-add = [ "ed25519=auth_ed25519" ];
    };
  };
  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        iifname wlan0 meta l4proto tcp ip6 saddr fda9:51fe:3bbf:c9f::/64 th dport 3306 accept
        iifname wlan0 meta l4proto tcp ip  saddr        192.168.238.0/24 th dport 3306 accept
      }
    }
  '';

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.openssh = {
    enable = true;
    hardening = true;
    ports = [ 562 ];
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00";
    flake = "github:reckenrode/nixos-configs";
  };

  system.stateVersion = "24.05";

  time.timeZone = "America/New_York";

  users.mutableUsers = false;

  users.users.builder = {
    description = "Remove Build User";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBB5nhmWs2pX0S8S2OQU9Eai9f6O7zHcFRGCBlgf+C/SiOgHEeHdojSXLOguJ2kDsR3GUMaI69vfmJ93FPapcQjc="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBFYJbdgZnKjzvOrUqsSjco2iwwJb50UwTnhEJvoybh"
    ];
  };

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;

    isNormalUser = true;
    extraGroups = [
      "wheel"
      "samba-guest"
    ];

    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOnacmxOzH6dRpX6Y+scSn3hkNi6DBFi5/ltIOr85FBk9gs3e6u0zsSlfbgQ8Wl+OvBku1U3jjjYvjKAkrsgBgs="
    ];
  };

  users.users.weiweilin = {
    description = "Weiwein Lin";
    shell = pkgs.shadow;

    isNormalUser = true;

    home = "/var/empty";
    createHome = false;
  };

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}
