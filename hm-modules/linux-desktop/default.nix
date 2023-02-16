{ config, pkgs, ... }@inputs:

let
    screenLayouts = {
        standalone = ./screenlayouts/standalone.sh;
        homeSingle = ./screenlayouts/home_single.sh; 
        homeDouble = ./screenlayouts/home_double.sh;
        school     = ./screenlayouts/school.sh; 
    };
in
{
    imports = [ (import ./xsession.nix screenLayouts) ];

    targets.genericLinux.enable = true;

    home.sessionVariables = {
        TERMINAL = "${pkgs.gnome.gnome-terminal}/bin/gnome-terminal";
    };
    
    home.packages = with pkgs; [
        nix
        nix-direnv          # Enables the `use nix` directive in `.envrc` files
        nix-zsh-completions # TODO does not work yet?

        lukestools
        lukespython3        # Custom python3 env

        gammastep           # Red light
        # autokey           # TODO manually managed so far, maybe add later?

        fzf
        tldr
        ncdu_2

        keepassxc
        veracrypt
        
        galculator

        thunderbird
        firefox
        # thunar            # TODO (install manually, see `README.md`)

        xournalpp
        filezilla
        flameshot

        # Messengers        
        signal-desktop
        tdesktop
        threema-desktop
        hexchat

        # Git tools
        meld
        gitg

        # Diagrams
        umlet
        dia

        # Deactivated
        # cachix
        # devenv

        # Nodejs
        nodePackages.node2nix

        # Haskell
        cabal2nix

        # Purescript
        purescript
        spago
        esbuild

        # Dhall
        dhall
        dhall-lsp-server
        dhall-json
        dhall-bash

        # Only here because `thunar-spawn-run` was deactivated
        dmenu
    ];

    xdg = {
        enable = true;
        configFile = {
            "Thunar".source  = ./xdg/Thunar;
        };
    };

    gtk.enable = true;

    programs.gnome-terminal = {
        enable = true;
        profile = {
            "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
                default = true;
                visibleName = "Default";
                audibleBell = false;
                boldIsBright = true;
                colors = {
                    foregroundColor = "rgb(211,211,211)";
                    backgroundColor = "rgb(16,16,16)";
                    palette = [
                        "rgb(46,52,54)"
                        "rgb(204, 0, 0)"
                        "rgb(78, 154, 6)"
                        "rgb(196, 160, 0)"
                        "rgb(52, 101, 164)"
                        "rgb(117, 80, 123)"
                        "rgb(6, 152, 154)" 
                        "rgb(211, 215, 207)"
                        "rgb(85, 87, 83)" 
                        "rgb(239, 41, 41)"
                        "rgb(138, 226, 52)" 
                        "rgb(252, 233, 79)"
                        "rgb(114, 159, 207)"
                        "rgb(173, 127, 168)"
                        "rgb(52, 226, 226)" 
                        "rgb(238, 238, 236)"
                    ];
                };
            };
        };
    };

    programs.direnv.enable = true;

    dconf.settings = {
        # Prevent IBus from overriding keyboard settings
        "desktop/ibus/general" = {
            use-system-keyboard-layout = true;
        };
    };
}