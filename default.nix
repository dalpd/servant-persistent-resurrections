{ compiler ? "ghc901" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  inherit (pkgs.haskell.lib) dontCheck;

  baseHaskellPkgs = pkgs.haskell.packages.${compiler};

  myHaskellPackages = baseHaskellPkgs.override {
    overrides = self: super: {
      servant-persistent-starter = self.callCabal2nix "servant-persistent-starter" (./.) { };

      relude = self.callCabal2nix "relude" sources.relude { };

      optics-th = self.optics-th_0_4;
      optics-extra = self.optics-extra_0_4;

      openapi3 = dontCheck super.openapi3;
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
