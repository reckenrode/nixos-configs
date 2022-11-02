{ lib
, stdenvNoCC
, callPackage
, fetchpatch
, desktopToDarwinBundle
, icoutils
, makeDesktopItem
, unzip
, writeShellApplication
, coreutils
, darwin
, dxvk
, pkgsCross
, wine64Packages
}:

let
  pname = "ffxiv";
  desktopName = "Final Fantasy XIV (Unofficial)";

  # This is a separate derivation to avoid unnecessary rebuilds that would require downloading
  # multiple GB unnecessarily.
  ffxivClient = callPackage ./ffxiv-client.nix { };

  moltenvk = darwin.moltenvk.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      (fetchpatch {
        name = "ffxiv-flicker.patch";
        url = "https://github.com/KhronosGroup/MoltenVK/files/9686958/zeroinit.txt";
        hash = "sha256-aORWU7zPTRKSTVF4I0D8rNthdxoZbioZsNUG0/Dq2go=";
      })
      ./command-storage-optimization.patch
#      (fetchpatch {
#        name = "command-storage-optimization.patch";
#        url = "https://patch-diff.githubusercontent.com/raw/KhronosGroup/MoltenVK/pull/1678.patch";
#        hash = "sha256-kmui3FcnxrQrDsswwFy3ZYk1l6Eg0MCv2mTiJGkI43s=";
#      })
    ];
  });

  wine64 = wine64Packages.unstable.override {
    inherit moltenvk;
    vulkanSupport = true;
    embedInstallers = true;
  };

  executable = writeShellApplication {
    name = pname;

    runtimeInputs = [ wine64 ];

    text = ''
      # Set paths for the game and its configuration.
      WINEPREFIX="''${XDG_DATA_HOME:-"$HOME/.local/share"}/ffxiv"
      FFXIVCONFIG="''${XDG_CONFIG_HOME:-"$HOME/.config"}/ffxiv"

      DXVK_CONFIG_FILE=$FFXIVCONFIG/dxvk.conf
      DXVK_LOG_PATH="''${XDG_STATE_HOME:-"$HOME/.local/state"}/ffxiv"
      DXVK_STATE_CACHE_PATH="''${XDG_CACHE_HOME:-"$HOME/.cache"}/ffxiv"

      mkdir -p "$DXVK_LOG_PATH" "$DXVK_STATE_CACHE_PATH"
      # Transform the log and state cache paths to a Windows-style path
      DXVK_CONFIG_FILE="z:''${DXVK_CONFIG_FILE//\//\\}"
      DXVK_LOG_PATH="z:''${DXVK_LOG_PATH//\//\\}"
      DXVK_STATE_CACHE_PATH="z:''${DXVK_STATE_CACHE_PATH//\//\\}"

      WINEDOCUMENTS=$WINEPREFIX/dosdevices/c:/users/$(whoami)/Documents
      FFXIVWINCONFIG="$WINEDOCUMENTS/My Games/FINAL FANTASY XIV - A Realm Reborn"
      FFXIVWINPATH="$WINEPREFIX/dosdevices/c:/Program Files/FFXIV"

      # Enable ESYNC and disable logging
      WINEDEBUG=-all
      WINEESYNC=1

      # Darwin MoltenVK compatibility settings
      if [[ "$(${coreutils}/bin/uname -s)" = "Darwin" ]]; then
        MVK_CONFIG_LOG_LEVEL=0
        MVK_CONFIG_RESUME_LOST_DEVICE=1
        MVK_CONFIG_VK_SEMAPHORE_SUPPORT_STYLE=1
        # Detect whether FFXIV is running on Apple Silicon
        if /usr/bin/arch -arch arm64 -c /bin/echo &> /dev/null; then
          # Enable Metal fences on Apple GPUs for better performance.
          MVK_CONFIG_FULL_IMAGE_VIEW_SWIZZLE=0
        else
          MVK_CONFIG_FULL_IMAGE_VIEW_SWIZZLE=1 # Required by DXVK on Intel and AMD GPUs.
        fi
        export MVK_CONFIG_RESUME_LOST_DEVICE \
          MVK_CONFIG_VK_SEMAPHORE_SUPPORT_STYLE MVK_CONFIG_FULL_IMAGE_VIEW_SWIZZLE
      fi

      export WINEPREFIX MVK_CONFIG_LOG_LEVEL WINEDEBUG WINEESYNC \
        DXVK_CONFIG_FILE DXVK_LOG_PATH DXVK_STATE_CACHE_PATH

      # Bootstrap the game if the prefix doesn’t already exist.
      if [ ! -d "$FFXIVWINPATH" ]; then
        ${lib.optionalString stdenvNoCC.isDarwin ''
          for value in LeftOptionIsAlt RightOptionIsAlt LeftCommandIsCtrl RightCommandIsCtrl; do
            wine64 reg add 'HKCU\Software\Wine\Mac Driver' /v $value /d Y /f  > /dev/null 2>&1
          done
        ''}
        # Set up overrides to make sure DXVK is being used.
        for dll in dxgi d3d11 mcfgthread-12; do
          wine64 reg add 'HKCU\Software\Wine\DllOverrides' /v $dll /d native /f > /dev/null 2>&1
        done
        mkdir -p "$WINEPREFIX" && wineboot --init
        mkdir -p "$FFXIVWINPATH/game/movie/ffxiv"
        cp -R "${ffxivClient}/boot" "$FFXIVWINPATH"
        cp "${ffxivClient}/game/ffxivgame.ver" "$FFXIVWINPATH/game"
        find "$FFXIVWINPATH" -type f -exec chmod 644 {} +
        find "$FFXIVWINPATH" -type d -exec chmod 755 {} +
      fi

      # The movies are big and won’t change with patches, so don’t copy them.
      for movie in "${ffxivClient}/game/movie/ffxiv/"*; do
        ln -sf "$movie" "$FFXIVWINPATH/game/movie/ffxiv/$(basename "$movie")"
      done

      # Set up XDG-compliant configuration for the game.
      if [ ! -d "$FFXIVCONFIG" ]; then
        rm "$WINEDOCUMENTS"
        mkdir -p "$(dirname "$FFXIVWINCONFIG")" "$FFXIVCONFIG"
        ln -s "$FFXIVCONFIG" "$FFXIVWINCONFIG"
        # echo "dxvk.enableAsync = true" > "$FFXIVCONFIG/dxvk.conf"
        ln -s "$FFXIVCONFIG/dxvk.conf" "$FFXIVWINPATH/boot/dxvk.conf"
      fi

      # Make sure DXVK and mcfgthreads reflect the latest versions in nixpkgs.
      for dll in ${lib.getBin dxvk}/x64/*; do
        dllname=$(basename "$dll")
        ln -sf "$dll" "$WINEPREFIX/dosdevices/c:/windows/system32/$dllname"
      done
      ln -sf \
        ${pkgsCross.mingwW64.windows.mcfgthreads}/bin/mcfgthread-12.dll \
        "$WINEPREFIX/dosdevices/c:/windows/system32/mcfgthread-12.dll"

      cd "$FFXIVWINPATH/boot" && wine64 ffxivboot64.exe
    '';
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname;
  inherit (ffxivClient) version;

  nativeBuildInputs = [ icoutils ]
    ++ lib.optional stdenvNoCC.isDarwin desktopToDarwinBundle;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    wrestool --type=14 -x ${ffxivClient}/boot/ffxivboot64.exe --output=.
    icotool -x ffxivboot64.exe_14_103_1041.ico --output=.

    local -rA widths=([1]=256 [2]=48 [3]=32 [4]=16)
    local -rA retina_widths=([1]=128 [2]=24 [3]=16 [4]=na)

    for index in "''${!widths[@]}"; do
      local width=''${widths[$index]}
      local retina_width=''${retina_widths[$index]}
      local res=''${width}x''${width}

      local -a icondirs=("$res/apps")
      if [[ $retina_width != 'na' ]]; then
        icondirs+=("''${retina_width}x''${retina_width}@2/apps")
      fi

      for icondir in "''${icondirs[@]}"; do
        mkdir -p "$icondir"
        cp ffxivboot64.exe_14_103_1041_''${index}_''${res}x32.png "$icondir/ffxiv.png"
      done
    done
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    type = "Application";
    comment = meta.description;
    desktopName = desktopName;
    categories = [ "Game" "RolePlaying" ];
    prefersNonDefaultGPU = true;
    startupNotify = false;
    extraConfig = {
      StartupWMClass = "ffxivboot64.exe";
      X-macOS-SquircleIcon = "false";
    };
  };

  installPhase = ''
    shopt -s extglob

    mkdir -p $out/share/icons/hicolor
    ln -s ${executable}/bin $out/bin
    cp -Rv {??,???}x{??,???}?(@2) $out/share/icons/hicolor
    ln -sv "${desktopItem}/share/applications" "$out/share/applications"
  '';

  meta = {
    description = "Unofficial client for the critically acclaimed MMORPG Final Fantasy XIV. FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.";
    homepage = "https://www.finalfantasyxiv.com";
    changelog = "https://na.finalfantasyxiv.com/lodestone/special/patchnote_log/";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.unfree;
    inherit (wine64.meta) platforms;
    hydraPlatforms = [ ];
  };
}

