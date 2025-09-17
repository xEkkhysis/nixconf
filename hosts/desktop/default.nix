{ lib, config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  
  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.supportedLocales = [ "de_DE.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

  services.xserver.xkb.layout = "de";
  services.xserver.xkb.variant = "nodeadkeys";
  services.xserver.xkb.options = "caps:swapescape";

  console.keyMap = "de-latin1-nodeadkeys";
  

  my.desktop.variant = "cosmic";  # or "cosmic"
  my.desktop.login   = "gdm";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tom = {
      imports =
        [
          ../../home/common.nix
          ../../home/zsh-omz.nix
          ../../home/fontcache.nix
          ../../home/foot.nix
        ]
        ++ lib.optionals (config.my.desktop.variant == "sway")   [ ../../home/swayfdir.nix ]
        ++ lib.optionals (config.my.desktop.variant == "cosmic") [ ../../home/cosmic.nix ];
    };
  };
}

