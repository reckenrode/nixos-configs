{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile map;
  inherit (lib) optionalAttrs types;
  inherit (lib.trivial) pipe;
  inherit (pkgs) stdenv substituteAll;
in
{
  options.services.dhcp6Client = {
    openFirewall = lib.mkEnableOption "Open the firewall to allow DHCPv6 on the specified interfaces";
    interfaces = lib.mkOption {
      default = [];
      defaultText = "[]";
      example = ''[ "enp1s0" ]'';
      description = "The interfaces for which to set up firewall rules to allow DHCPv6";
      type = types.listOf types.string;
    };
  };
  config =
    let
      inherit (config.services.dhcp6Client) interfaces;

      generateFirewallRules = interface: readFile (pkgs.substituteAll {
        inherit interface;
        src = ./dhcp6Client.nft;
      });
    in
    lib.mkIf config.services.dhcp6Client.openFirewall {
      networking.nftables.ruleset = pipe interfaces [
        (map generateFirewallRules)
        (builtins.concatStringsSep "\n")
      ];
    };
}
