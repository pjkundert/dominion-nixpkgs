{ ... } @ args: import ./nixpkgs (
  args // {
    overlays = (import ./overlays) ++ (args.overlays or [ ]);
  }
)
