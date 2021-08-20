{ config, lib, pkgs, ... }:

{
  home.activation = {
    copyApplications = let
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        app_folder="$HOME/Applications/Home Manager Apps Test";
        mkdir -p "$app_folder"

        IFS=$'\n'
        old_paths=($(mdfind kMDItemKind="Alias" -onlyin "$app_folder"))
        new_paths=($(find "$genProfilePath/home-path/Applications" -name '*.app' -type l))
        unset IFS

        old_size="''${#old_paths[@]}"
        echo "removing $old_size aliased apps from $app_folder"
        for i in "''${!old_paths[@]}"; do
          $DRY_RUN_CMD rm -f "''${old_paths[$i]}"
        done

        new_size="''${#new_paths[@]}"
        echo "adding $new_size aliased apps into $app_folder"

        for i in "''${!new_paths[@]}"; do
          real_app=$(realpath "''${new_paths[$i]}")
          app_name=$(basename "''${new_paths[$i]}")
          $DRY_RUN_CMD rm -f "$app_folder/$app_name"
          $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_folder/$app_name"
        done
     '';
   };
 }
