{ lib, pkgs, config, ... }:
let
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    variant = lib.mkOption {
      type = lib.types.enum [ "sway" "cosmic" ];
      default = "sway";
      description = "Select desktop environment.";
    };
    login = lib.mkOption {
      type = lib.types.enum [ "gdm" "cosmic-greeter" "greetd" ];
      default = "gdm";
      description = "Display/login manager to use.";
    };
  };

  config = {
    services.xserver.enable = true;

    # GDM (default)
    services.displayManager.gdm.enable = (cfg.login == "gdm");
    services.displayManager.gdm.wayland = (cfg.login == "gdm");

    # COSMIC greeter (optional)
    services.displayManager.cosmic-greeter.enable = (cfg.login == "cosmic-greeter");

    # greetd (only meaningful for sway)
    services.greetd = lib.mkIf (cfg.login == "greetd" && cfg.variant == "sway") {
      enable = true;
      settings.default_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "tom";
      };
    };

    # Desktop branches
    programs.sway.enable = (cfg.variant == "sway");

    services.desktopManager.cosmic.enable = (cfg.variant == "cosmic");

    # Wayland helpers for Sway
    xdg.portal.enable = true;
    xdg.portal.wlr.enable = lib.mkIf (cfg.variant == "sway") true;
    hardware.opengl.enable  = lib.mkIf (cfg.variant == "sway") true;
    environment.variables.WLR_NO_HARDWARE_CURSORS =
      lib.mkIf (cfg.variant == "sway") "1";

    # Fonts, printing, BT, Flatpak
    fonts.packages = with pkgs; [
      noto-fonts noto-fonts-cjk-sans noto-fonts-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    services.printing.enable = true;
    hardware.bluetooth.enable = true;
    services.flatpak.enable = true;

    # Make Zsh the default shell on desktop systems
    programs.zsh.enable = true;
    environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;
  };
}
