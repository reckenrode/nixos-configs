final: prev:

prev.iterm2.overrideAttrs (old: {
  postFixup = ''
    ${prev.lib.optionalString (old ? postFixup) old.postFixup}
    ITERM_APP=$out/Applications/iTerm.app
    SIGNING_IDENTITY="Mac Developer: Randy Eckenrode (HTQ4MRCN98)"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" --deep "$ITERM_APP"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" --entitlements plists/iTermServer.entitlements \
      "$ITERM_APP/Contents/MacOS/ShellLauncher"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" --entitlements iTerm2.entitlements \
      "$ITERM_APP/Contents/MacOS/iTerm2"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" --entitlements plists/iTermServer.entitlements \
      "$ITERM_APP/Contents/MacOS/iTermServer"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" \
      --entitlements iTerm2SandboxedWorker/iTerm2SandboxedWorker.entitlements \
      "$ITERM_APP/Contents/XPCServices/iTerm2SandboxedWorker.xpc"
    /usr/bin/codesign -f -s "$SIGNING_IDENTITY" --entitlements pidinfo/pidinfo.entitlements \
      "$ITERM_APP/Contents/XPCServices/pidinfo.xpc"
  '';
})
