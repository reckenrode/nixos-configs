{ lib, flakePkgs, pkgs, ... }:

let
  foundryvtt = flakePkgs.foundryvtt.override {
    inherit (pkgs) pngout;
  };
in
{
  services.foundryvtt = {
    enable = true;
    hostname = "vtt.largeandhighquality.com";
    minifyStaticFiles = true;
    package = foundryvtt;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };

  systemd.mounts = [
    {
      what = "overlay";
      where = "/srv/vtt";
      type = "overlay";
      options = "lowerdir=${foundryvtt}/public:${foundryvtt.gzip}:${foundryvtt.zstd}:${foundryvtt.brotli}";
      before = [ "foundryvtt.service" ];
      wantedBy = [ "foundryvtt.service" ];
    }
  ];
}
