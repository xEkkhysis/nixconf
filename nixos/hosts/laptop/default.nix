{ self, ... }:
{
  networking.hostName = "laptop";
  nixpkgs.hostPlatform = "x86_64-linux";

  i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:swapescape";
  };

  console.keyMap = "de-latin1-nodeadkeys";

  profiles.storage.btrfs.enable = true;
  profiles.storage.btrfs.device = "/dev/nvme0n1";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tom = {
      imports = [
        (self + /home/modules/core.nix)
        (self + /home/modules/programs/foot.nix)
        (self + /home/modules/shells/oh-my-zsh.nix)
        (self + /home/modules/desktop/cosmic.nix)
      ];
    };
  };
}
