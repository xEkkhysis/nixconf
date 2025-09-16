{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = { opacity = 0.95; dynamic_title = true; };
      font = {
        normal = { family = "FiraCode Nerd Font"; style = "Regular"; };
        bold   = { family = "FiraCode Nerd Font"; style = "Bold"; };
        size = 11.0;
      };
      scrolling = { history = 10000; multiplier = 3; };
      cursor = { style = "Beam"; };
      key_bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
      ];
    };
  };
}
