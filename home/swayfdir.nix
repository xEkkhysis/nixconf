{ pkgs, lib, ... }:

let
  # Your repo folder with the upstream Sway configs (tracked by git!)
  srcDir = ../swayconfig;

  # Patch the files so they match your stack (Foot + Zsh, no swaybar blocks)
  patched = pkgs.runCommandLocal "swayconfig-patched" {} ''
    set -eu
    mkdir -p "$out"
    cp -r "${srcDir}"/. "$out/"

    # Replace terminals & shell (best-effort in text files)
    find "$out" -type f \
      -exec sed -i \
        -e 's/\btermite\b/foot/g' \
        -e 's/\balacritty\b/foot/g' \
        -e 's/bash -lc/zsh -lc/g' \
        -e 's/bash -c/zsh -c/g' \
      {} +

    # Comment "bar {" headers so swaybar won’t spawn even if present
    find "$out" -type f \( -name '*.conf' -o -name '*.config' -o -name 'config' \) \
      -exec sed -i 's/^\s*bar\s*{/# bar {/' {} +
  '';
in
{
  # Ensure the apps exist
  programs.foot.enable = true;
  programs.waybar.enable = true;
  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.package = pkgs.sway;

  # Ship *all* your configs under ~/.config/sway/external
  xdg.configFile.".config/sway/external".source = patched;

  # We fully control ~/.config/sway/config here:
  # - set Foot, Mod4
  # - autostart Waybar + a solid-color wallpaper (no bottom bar)
  # - then include everything from swayconfig/
  xdg.configFile.".config/sway/config".text = ''
    set $mod Mod4
    set $term foot

    exec_always --no-startup-id ${pkgs.waybar}/bin/waybar
    exec_always --no-startup-id ${pkgs.swaybg}/bin/swaybg -c "#1e1e2e"

    include ~/.config/sway/external/*.config
    include ~/.config/sway/external/*.conf
    include ~/.config/sway/external/config
  '';
}

