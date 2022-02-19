final: prev: {
  haskellPackages = prev.haskellPackages.override (old: {
    overrides = prev.lib.composeExtensions (old.overrides or (_: _: {}))
    (hself: hsuper: {
      selene-taffybar-dark = hself.callCabal2nix "selene-taffybar-dark"
      (
        final.lib.sourceByRegex ./.
        ["taffybar.hs" "selene-taffybar-dark.cabal" "taffybar-dark.css"]
      )
      { };
    });
  });
}
