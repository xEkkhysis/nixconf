{ lib, pkgs, ... }:
{
  # Headless: keep bash default, but install zsh via base
  services.openssh.enable = true;  # SSH server only on headless
}
