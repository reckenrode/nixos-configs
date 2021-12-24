final: prev:

prev.iterm2.overrideAttrs (old: {
  preBuild = ''
    ${prev.lib.optionalString (old ? preBuild) old.preBuild}
    sed -i "s/3.4.%(extra)s/${old.version}/" version.txt
  '';

  postFixup = ''
    ${prev.lib.optionalString (old ? postFixup) old.postFixup}
    ITERM_APP=$out/Applications/iTerm.app
    /usr/bin/codesign --deep -s - -i com.googlecode.iterm2 \
      --entitlements iTerm2.entitlements \
      $ITERM_APP
    /usr/bin/codesign -f -s - \
      --entitlements plists/iTermServer.entitlements \
      $ITERM_APP/Contents/MacOS/iTermServer
    /usr/bin/codesign -f -s - \
      --entitlements iTerm2SandboxedWorker/iTerm2SandboxedWorker.entitlements \
      $ITERM_APP/Contents/XPCServices/iTerm2SandboxedWorker.xpc
    /usr/bin/codesign -f -s - \
      --entitlements pidinfo/pidinfo.entitlements \
      $ITERM_APP/Contents/XPCServices/pidinfo.xpc
  '';
})
