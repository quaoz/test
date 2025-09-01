{
  inputs,
  lib,
  ...
}: {
  perSystem = _: {
    agenix-rekey.nixosConfigurations =
      lib.filterAttrs
      (_: v: v.config ? age)
      (inputs.self.nixosConfigurations // inputs.self.darwinConfigurations);
  };
}
