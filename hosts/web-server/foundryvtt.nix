# SPDX-License-Identifier: MIT

{ pkgs, inputs, ... }:

let
  foundryvtt = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt.override {
    inherit (pkgs) pngout;
  };
in
{
  services.foundryvtt = {
    enable = true;
    hostName = "vtt.largeandhighquality.com";
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
