{ config, pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
                "fzf"
                "zsh-interactive-cd"
                "fasd"
                "docker"
                "docker-compose"
            ];
        };
    };
}