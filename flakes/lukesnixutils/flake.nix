{
    description = ''
        Some personal Nix utility functions
    '';

    inputs = { };

    outputs = { self, ... }: {
        lib = import ./.;
    };
}