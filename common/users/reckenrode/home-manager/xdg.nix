{ config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Movies";
  };
}
