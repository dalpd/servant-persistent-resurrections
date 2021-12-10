{ compiler ? "ghc921" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  inherit (pkgs.haskell.lib) dontCheck;

  baseHaskellPkgs = pkgs.haskell.packages.${compiler};

  myHaskellPackages = baseHaskellPkgs.override {
    overrides = hself: hsuper: {
      servant-persistent-starter = hself.callCabal2nix "servant-persistent-starter" (./.) { };
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: with p; [
      servant-persistent-starter
    ];

    buildInputs = with pkgs.haskellPackages; [
      cabal-install
      ghcid
      ormolu
      hlint
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];

    libraryHaskellDepends = [
    ];

    shellHook = ''
      set -e
      hpack
      set +e
    '';
  };

in
{
  inherit shell;
  inherit myHaskellPackages;
  servant-persistent-starter =
    myHaskellPackages.servant-persistent-starter;
}
