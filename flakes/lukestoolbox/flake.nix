{
    description = ''
        Personal toolbox of scripts and tools. This is only the public part.
        - `lukespylib` is a python3 package that provides some common helper functions.
        - `lukespython3` is a python3 environment with the `lukespylib` package included.
        - `lukestools` is a set of scripts that are used for everyday things, written in bash or python3.
    '';

    inputs = {
        # External inputs
        nixpkgs.url   = "github:NixOS/nixpkgs/nixos-22.11";
        # Use an old version for python packaging to prevent this error:
        # https://discourse.nixos.org/t/python-packages-are-not-building-modulenotfounderror-no-module-named-setuptools/22232/3
        nixpkgs-1.url = "github:NixOS/nixpkgs/nixos-22.11";
        utils.url     = "github:numtide/flake-utils";

        # Public local inputs
        lukesnixutils.url = path:../lukesnixutils;
        externaltoolbox.url = path:../externaltoolbox;
    };

    outputs = { self, nixpkgs, nixpkgs-1, lukesnixutils, utils, ... }@inputs:
        utils.lib.eachDefaultSystem (system:
        let
            overlayFlakes = with inputs; [externaltoolbox];
            overlayPackages = {};

            pkgs   = lukesnixutils.lib.instantiateNixpkgs system nixpkgs   overlayFlakes overlayPackages;
            pkgs-1 = lukesnixutils.lib.instantiateNixpkgs system nixpkgs-1 overlayFlakes overlayPackages;
        in

        {
            packages = 
            {
                lukespylib =
                    pkgs-1.python3Packages.buildPythonPackage {
                        pname = "lukespylib";
                        version = "0.1.0";
                        src = ./lukespylib;
                        format = "pyproject";
                    };

                lukespython3 =
                    let
                        # Python env with the `lukespylib` package
                        pythonPackages = pythonPkgs: with pythonPkgs; [
                            self.packages.${system}.lukespylib # lukespylib
                            i3ipc                              # bindings for i3 IPC
                            pygobject3                         # bindings for GTK3
                        ];
                        thePythonPkg = pkgs-1.python3.withPackages pythonPackages;
                    in
                        # This package is essentially a wrapper for the python env,
                        # providing the `lukespython3` executable.
                        # It also adds the GAppsHooks env vars that are needed for GTK apps.
                        pkgs-1.stdenv.mkDerivation {
                            pname = "lukespython3";
                            version = "0.1.0";
                            buildInputs = [
                                pkgs-1.gtk3  # For python apps that build on GTK
                                thePythonPkg
                            ];
                            nativeBuildInputs = [
                                pkgs-1.gobject-introspection # Contains a setup hook for GTK python library: GI_TYPELIB_PATH etc. gets set
                                # Notice: `wrapGAppsHook` overrides `makeWrapper` by `makeBinaryWrapper`
                                pkgs-1.wrapGAppsHook         # Collect env variables and set them in the wrapper
                            ];
                            unpackPhase = "true";
                            installPhase = ''
                                mkdir -p $out/bin
                                ln -s ${thePythonPkg}/bin/python3 $out/bin/lukespython3
                            '';
                        };
                
                lukestools =
                    let
                        scriptDeps = import ./lukestools.nix pkgs;
                    in
                
                    pkgs-1.stdenv.mkDerivation {
                        pname = "lukestools";
                        version = "0.1.0";
                        src = ./lukestools;
                        buildInputs = [
                            # For scripts written in python. Gets automatically injected into the scripts by `patchShebangs` 
                            self.packages.${system}.lukespython3
                        ];
                        nativeBuildInputs = [
                            # For scripts that have dependencies: Explicitly prepare $PATH via wrapper.
                            # Use `makeBinaryWrapper` instead of `makeWrapper` (due to MacOS limitation)
                            pkgs.makeBinaryWrapper
                        ];
                        installPhase = ''
                            mkdir -p $out/bin
                            cp $src/* $out/bin
                        '';
                        postFixup =
                            let
                                prepareEntry = entry:
                                    if entry.deps != [] then
                                        "wrapProgram $out/bin/${entry.script} --prefix PATH : ${pkgs-1.lib.makeBinPath entry.deps} "
                                    else
                                        "";
                                
                                lines = builtins.map
                                    prepareEntry
                                    scriptDeps;
                            in
                                builtins.concatStringsSep "\n" lines;
                    };

                default = self.packages.${system}.lukestools;
            };   
                
            devShells.default = self.packages.${system}.default;
        });
}