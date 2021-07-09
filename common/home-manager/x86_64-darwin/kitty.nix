{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Font settings
      font_family = "SFMono-Regular";
      bold_font = "SFMono-Bold";
      italic_font = "SFMono-RegularItalic";
      bold_italic_font = "SFMono-BoldItalic";
      font_size = 11;
      # Adjust the metrics to match iTerm2 and Terminal.app
      adjust_line_height = 2;
      adjust_baseline = "-3.571425%";
      window_padding_width = "0.5 2.5";
      # Window Settings
      remember_window_size = false;
      initial_window_width = "100c";
      initial_window_height = "40c";
      macos_show_window_title_in = "window";
    };
  };
}
