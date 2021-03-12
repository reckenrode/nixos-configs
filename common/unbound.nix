{ pkgs, ... }:
{
  networking.nftables.ruleset = builtins.readFile ./unbound.nft;

  services.unbound = {
    enable = true;
    extraConfig = builtins.readFile ./unbound.conf;
  };
}
