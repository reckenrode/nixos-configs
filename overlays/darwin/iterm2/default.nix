final: prev:

prev.iterm2.overrideAttrs (old: {
  buildInputs = [ prev.darwin.cctools prev.darwin.sigtool ];

  preBuild = ''
    ${prev.lib.optionalString (old ? preBuild) old.preBuild}
    sed -i "s/3.4.%(extra)s/${old.version}/" version.txt
  '';

  postFixup = ''
    ${prev.lib.optionalString (old ? postFixup) old.postFixup}
    ITERM_APP=$out/Applications/iTerm.app
    codesign -f -s - -i com.googlecode.iterm2 --entitlements iTerm2.entitlements \
      $ITERM_APP/Contents/MacOS/iTerm2
    codesign -f -s - --entitlements plists/iTermServer.entitlements \
      $ITERM_APP/Contents/MacOS/iTermServer
    codesign -f -s - --entitlements iTerm2SandboxedWorker/iTerm2SandboxedWorker.entitlements \
      $ITERM_APP/Contents/XPCServices/iTerm2SandboxedWorker.xpc/Contents/MacOS/iTerm2SandboxedWorker
    codesign -f -s - --entitlements pidinfo/pidinfo.entitlements \
      $ITERM_APP/Contents/XPCServices/pidinfo.xpc/Contents/MacOS/pidinfo
  '';
})
