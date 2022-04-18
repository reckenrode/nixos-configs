{ config
, ...
}:

{
  # Move Cache home to ~/Library/Caches, so it plays nicely with backups
  xdg.cacheHome = "${config.home.homeDirectory}/Library/Caches";
}
