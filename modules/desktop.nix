{ lib, pkgs, config, ... }:
let
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    variant = lib.mkOption {
      type = lib.types.enum [ "sway" "cosmic" ];
      default = "cosmic";  # you said you'll use COSMIC for now
      description = "Select desktop environment.";
    };
    login = lib.mkOption {
      type = lib.types.enum [ "gdm" "cosmic-greeter" "greetd" ];
      default = "cosmic-greeter";
      description = "Display/login manager to use.";
    };
  };

  config = {
    services.xserver.enable = true;

    # Display managers
    services.displayManager.gdm.enable = (cfg.login == "gdm");
    services.displayManager.gdm.wayland = (cfg.login == "gdm");
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

    # Portals
    xdg.portal.enable = true;
    # Sway-specific portal
    xdg.portal.wlr.enable = lib.mkIf (cfg.variant == "sway") true;
    # COSMIC portals
    xdg.portal.extraPortals = lib.mkIf (cfg.variant == "cosmic") (with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-cosmic
    ]);

    # Graphics (needed for both Sway and COSMIC)
    hardware.graphics.enable = true;

    # Only set this WLR var on Sway
    environment.variables.WLR_NO_HARDWARE_CURSORS =
      lib.mkIf (cfg.variant == "sway") "1";

    # Audio (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Fonts, printing, BT, Flatpak
    fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    services.printing.enable = true;
    hardware.bluetooth.enable = true;
    services.flatpak.enable = true;

    # Zsh as default shell on desktop systems
    programs.zsh.enable = true;
    environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;
  };
}
