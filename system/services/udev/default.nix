{pkgs, ...}: {
  services.udev = {
    packages = [pkgs.openrgb];
  };
}
