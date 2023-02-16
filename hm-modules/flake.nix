{
    description = "
        Flake for public hm-modules.
    ";

    inputs = { };

    outputs = { self, ... }: {
        nixosModules.common = import ./common;
        nixosModules.linux-desktop = import ./linux-desktop;
        nixosModules.zsh = import ./zsh;
    };
}