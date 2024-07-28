# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./letsencrypt.nix
    ./caddy.nix
    #    ./coturn.nix
    ./foundryvtt.nix
    ./reverse-proxy.nix
  ];

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;

  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  home-manager.users.reckenrode = inputs.self.hmModules.server-admin;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "pngout" ];

  networking.hostName = "web-server";

  networking.nftables.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  programs.fish.enable = true;

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
  system.stateVersion = "22.11";

  systemd.network.networks.wan = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = true;
    };
  };

  time.timeZone = "America/New_York";

  users.mutableUsers = false;

  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;

    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOnacmxOzH6dRpX6Y+scSn3hkNi6DBFi5/ltIOr85FBk9gs3e6u0zsSlfbgQ8Wl+OvBku1U3jjjYvjKAkrsgBgs="
    ];
  };

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}
