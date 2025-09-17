{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  programs.firefox = {
    enable = true;
    profiles.default.settings."browser.startup.homepage" = "https://google.com";
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };

  home.packages = with pkgs; [
    discord
    keepassxc
    nextcloud-client
    yubikey-personalization
    yubikey-manager
    yubioath-flutter
    wireguard-tools
    networkmanagerapplet
    networkmanager-openconnect
    openconnect
    jetbrains.rust-rover
    dbeaver-bin
  ];
}
