{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    xdgOpenUsePortal = true;
    wlr.enable = false; #conflict with XDPH if enabled
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
