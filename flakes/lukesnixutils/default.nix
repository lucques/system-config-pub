let
    # Parameters:
    # - `system` (string): The system to use
    # - `flakes` (list of flakes): The flakes to use
    # Outputs a list of packages
    collectPackagesFromFlakeInputs = system: flakes:
        builtins.foldl' (acc: flake: acc // (removeAttrs flake.packages.${system} ["default"])) {} flakes;

    # Parameters:
    # - `system` (string): The system to use
    # - `nixpkgs` (derivation): The nixpkgs drv
    # - `overlayFlakes`   (list of flakes):   The flakes whose packages to use in overlay
    # - `overlayPackages` (set of packages): Packages to use in overlay
    instantiateNixpkgs = system: nixpkgs: overlayFlakes: overlayPackages:
        let
            allOverlayPackages = (collectPackagesFromFlakeInputs system overlayFlakes)
                                 // overlayPackages;
        in
        import nixpkgs
        {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (self: super: allOverlayPackages) ];
        };

    # Creates a home-manager module with the following properties:
    # 1) Configuration for the `home` config of home-manager
    # 2) Configuration for the local Nix registry
    # Parameters
    # - `username` (string)
    # - `rev`      (string) nixpkgs revision 
    mkHomeManagerBasicModule = username: rev: {
        home = {
            inherit username;
            homeDirectory = "/home/${username}";
        };
        nix.registry.nixpkgs = {
            from = {
                type = "indirect";
                id = "nixpkgs";
            };
            to = {
                type = "github";
                owner = "NixOS";
                repo = "nixpkgs";
                inherit rev;
            };
        };
    };
        

    # Can be used e.g. to sym-link from `custom_python3` to some executable `.../python3`
    # Parameters:
    # - `path` (string): The path to the executable
    # - `name` (string): The name of the executable
    symlinkToBin = pkgs: path: name:
        pkgs.runCommand name {} ''
            mkdir -p $out/bin
            ln -s ${path} $out/bin/${name}
        '';
in
{
    inherit
        collectPackagesFromFlakeInputs
        instantiateNixpkgs
        mkHomeManagerBasicModule
        symlinkToBin;
}