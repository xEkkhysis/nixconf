{ pkgs, ... }:
{
  programs.waybar.enable = true;
  programs.wofi.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      keybindings = {
        "Mod4+Return" = "alacritty";
        "Mod4+d" = "wofi --show drun";
        "Mod4+Shift+q" = "swaymsg exit";
        "Mod4+Shift+r" = "swaymsg reload";
        "Print" = "grim -g \"$(slurp)\" - | wl-copy";
      };
      startup = [
        { command = "waybar"; always = true; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
      ];
    };
  };

  home.packages = with pkgs; [
    wl-clipboard grim slurp swappy swaybg swayidle swaylock
    blueman
  ];
}
