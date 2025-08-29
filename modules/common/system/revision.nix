{
  self,
  pkgs,
  ...
}: {
  system = {
    stateVersion = self.lib.ldTernary pkgs "25.05" 4;

    configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
  };
}
