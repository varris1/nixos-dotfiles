{ ... }:
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/plain" = "nvim.desktop";

      "image/jpeg" = "sxiv.desktop";
      "image/png" = "sxiv.desktop";
      "image/svg" = "sxiv.desktop";
    };
  };
}

