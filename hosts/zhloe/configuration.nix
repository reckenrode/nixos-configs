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
    ./kea.nix
    ./systemd-networkd.nix
    ./unbound.nix
  ];

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_hardened;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  home-manager.users.reckenrode = inputs.self.hmModules.server-admin;

  networking.hostName = "zhloe";

  networking.nftables.enable = true;

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "meteion.infra.largeandhighquality.com";
        protocol = "ssh-ng";
        sshUser = "builder";
        sshKey = "/root/.ssh/id_meteon_builder";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZqSTEwaVM0VklNMVpuOUxnV0wydG1YY0lhUTROTGtjS1JUTkNQSjQ0U2ggcm9vdEBtZXRlaW9uCg==";
        supportedFeatures = [
          "kvm"
          "benchmark"
          "big-parallel"
        ];
        system = "x86_64-linux";
      }
    ];
  };

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

  programs.ssh.extraConfig = lib.mkAfter ''
    Host meteion.infra.largeandhighquality.com
      Port 562
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

  system.stateVersion = "24.11";

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
}
