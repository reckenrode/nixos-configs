{ ... }:

{
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  '';
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "meteia" "ultima-thule" ];
}
