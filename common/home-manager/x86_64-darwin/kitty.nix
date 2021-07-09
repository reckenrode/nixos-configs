{ pkgs, ... }:

{
  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  programs.kitty = {
    enable = true;
    keybindings = {
      "cmd+n" = "new_os_window_with_cwd";
      "cmd+t" = "new_tab_with_cwd";
    };
    settings = {
      # Font settings
      font_family = "SFMono-Regular";
      bold_font = "SFMono-Bold";
      italic_font = "SFMono-RegularItalic";
      bold_italic_font = "SFMono-BoldItalic";
      font_size = 11;
      # Adjust the metrics to match iTerm2 and Terminal.app
      adjust_line_height = 2;
      window_padding_width = "1.5 2.5";
      # Window Settings
      remember_window_size = false;
      confirm_os_window_close = 1;
      initial_window_width = "100c";
      initial_window_height = "40c";
      macos_show_window_title_in = "window";
      resize_in_steps = true;
    };
  };
}
