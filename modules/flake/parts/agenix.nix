{
  self,
  lib,
  ...
}: {
  perSystem = _: {
    agenix-rekey.nixosConfigurations =
      lib.filterAttrs
      (_: v: v.config ? age)
      (self.nixosConfigurations // self.darwinConfigurations);
  };
}
