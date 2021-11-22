final: prev: {
  haskellPackages = prev.haskellPackages.override (old: {
    overrides = prev.lib.composeExtensions (old.overrides or (_: _: {}))
    (hself: hsuper: {
      selene-taffybar = hself.callCabal2nix "selene-taffybar"
      (
        final.lib.sourceByRegex ./.
        ["taffybar.hs" "selene-taffybar.cabal" "taffybar.css"]
      )
      { };
    });
  });
}