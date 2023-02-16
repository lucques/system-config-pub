{ config, pkgs, ... }:

let
    enLocale = "en_US.utf8";
    deLocale = "de_DE.utf8";
in

{
    # Home Manager: For which version shall the default values be used for config?
    home.stateVersion = "22.11";

    programs.bash.enable = true;
    programs.bash.profileExtra =
        # TODO put TERMINAL somewhere else (linux-specific)
        # TODO TERMINAL is also set as a sessionVariable, needed here, too?
        # TODO ghcup in Bash needed?
        ''
            export PATH=$HOME/bin:$PATH
            export TERMINAL=${pkgs.gnome.gnome-terminal}/bin/gnome-terminal
            #. $HOME/.ghcup/env   # TODO is this the right place?
        '';
    
    nix = {
        enable = true;
        package = pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            substituters = [
                "https://cache.nixos.org"
                # "https://devenv.cachix.org"
            ];
            trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            ];
        };
    };

    home.language = {
        # English
        base = "${enLocale}";
        ctype = "${enLocale}";
        numeric = "${enLocale}";
        collate = "${enLocale}";
        messages = "${enLocale}";
        # German
        time = "${deLocale}";
        monetary = "${deLocale}";
        paper = "${deLocale}";
        name = "${deLocale}";
        address = "${deLocale}";
        telephone = "${deLocale}";
        measurement = "${deLocale}";
    };

    # Disable keyboard management via Home Manager
    home.keyboard = null;

    programs.home-manager.enable = true;
}
