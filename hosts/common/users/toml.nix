{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.toml = {
    initialHashedPassword = "$y$j9T$rmwBqktbn4oTW4v2iToL.1$Xc75ljxpek.YKK.goNUethdyIAjG7GirwWT8pOBZMn/";
    isNormalUser = true;
    description = "toml";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoGoQl95LJ1urr0U2iB36KVbTLt4b1s8OL/xUQWdXmT"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlozEoR6VOZmKFrFX+OvgXLWMN8tgYX6yzCB8acbV8U"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.toml =
    import ../../../home/toml/${config.networking.hostName}.nix;
}
