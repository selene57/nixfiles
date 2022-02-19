final: prev: {
  haskellPackages = prev.haskellPackages.override (old: {
    overrides = prev.lib.composeExtensions (old.overrides or (_: _: {}))
    (hself: hsuper: {
      selene-taffybar-light = hself.callCabal2nix "selene-taffybar-light"
      (
        final.lib.sourceByRegex ./.
        ["taffybar.hs" "selene-taffybar-light.cabal" "taffybar-light.css"]
      )
      { };
    });
  });
}
