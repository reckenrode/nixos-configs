{ config
, ...
}:

{
  home.sessionVariables.DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
}
