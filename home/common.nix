{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  # Core desktop apps (managed)
  programs.firefox = {
    enable = true;
    profiles.default.settings."browser.startup.homepage" = "https://google.com"\;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ rust-lang.rust-analyzer ];
  };

  programs.thunderbird.enable = true;

  # Extra desktop apps
  home.packages = with pkgs; [
    discord                             # unfree
    keepassxc
    nextcloud-client
    # YubiKey tools
    yubikey-personalization yubikey-manager  # ykpersonalize, ykman
    yubioath-flutter                    # Yubico Authenticator
    # VPN stack (via NetworkManager)
    wireguard-tools
    networkmanagerapplet
    networkmanager-openconnect openconnect
    networkmanager-wireguard
    # JetBrains RustRover (unfree)
    jetbrains.rust-rover
    # SQL client GUI (OSS)
    dbeaver
  ];
}
