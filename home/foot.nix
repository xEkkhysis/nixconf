{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = { font = "FiraCode Nerd Font:size=11"; };
      scrollback = { lines = 10000; };
      mouse = { hide-when-typing = "yes"; };
    };
  };
}
