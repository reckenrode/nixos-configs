{ ... }:

{
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  services.resolved.enable = true;
}
