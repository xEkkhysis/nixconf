{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "fzf" "docker" "kubectl" "z" ];
    };
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    history = { size = 50000; save = 50000; share = true; };
    shellAliases = {
      ll = "eza -alh --git";
      gs = "git status -sb";
      gc = "git commit";
      gp = "git push";
    };
    initExtra = ''
      export EDITOR=nvim
      bindkey -e
    '';
  };

  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [ eza bat ripgrep fd jq yq just ];
}
