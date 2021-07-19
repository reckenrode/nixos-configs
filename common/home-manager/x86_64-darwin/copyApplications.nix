{ config, lib, pkgs, ... }:

{
  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      appsSrc="${apps}/Applications"
      baseDir="$HOME/Applications/Home Manager Apps"

      # Need to make the directories writeable because `rm` will fail otherwise.
      $DRY_RUN_CMD chmod -R +w ''${VERBOSE_ARG:+-v} "$baseDir" \
        && $DRY_RUN_CMD rm -rf ''${VERBOSE_ARG:+-v} "$baseDir"

      for app in "$appsSrc"/*; do
	# Instead of symlinking into the home-manager buildEnv, symlink to the original app
	# in the Nix store.  The buildEnv is just a convenient way of getting all the packages
	# with .app bundles.  This helps avoid macOS TCC nagging when an app doesn’t change
	# during a generation switch.
        app=$(readlink "$app")

        appName=$(basename "$app")
        stagedApp="$baseDir/$appName"

        # Copy Contents/Info.plist to make the app searchable by Spotlight
        $DRY_RUN_CMD mkdir -p ''${VERBOSE_ARG:+-v} "$stagedApp/Contents"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} \
	  "$app/Contents/Info.plist" "$stagedApp/Contents/Info.plist"

        # Do any apps even do this? Might as well check just in case ….
        for file in "$app"/*; do
          filename=$(basename "$file")
          [ $filename != "Contents" ] \
	    && $DRY_RUN_CMD ln -s ''${VERBOSE_ARG:+-v} "$file" "$stagedApp"
        done

        for file in "$app/Contents"/*; do
          case "$file" in
            # VS Code and (presumably) other Electron apps don’t work right if these are symlinks
            "$app/Contents/MacOS" | "$app/Contents/Frameworks")
              $DRY_RUN_CMD cp -r ''${VERBOSE_ARG:+-v} "$file" "$stagedApp/Contents"
              ;;
            "$app/Contents/Info.plist")
              ;;
            *)
              filename=$(basename "$file")
              $DRY_RUN_CMD ln -s ''${VERBOSE_ARG:+-v} "$file" "$stagedApp/Contents"
              ;;
           esac
        done
      done

      $DRY_RUN_CMD find "$baseDir" -mindepth 1 -print0 | TZ=UTC xargs -0 touch -ht 197001010000.00
      $DRY_RUN_CMD chmod -R -w ''${VERBOSE_ARG:+-v} "$baseDir"/*
    '';
  };
}
