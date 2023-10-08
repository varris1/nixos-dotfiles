{
  pkgs,
  lib,
  ...
}: {
  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
    prunePaths = lib.mkOptionDefault [];
    interval = "hourly";
  };
}
