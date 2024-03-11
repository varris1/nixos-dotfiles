{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    extraPackages = [pkgs.libvdpau-va-gl];
    driSupport32Bit = true;
  };

  hardware.steam-hardware.enable = true;

  hardware.bluetooth.enable = true;
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };
}
