{defaults, ...}: {
  home = {
    stateVersion = "24.05";
  };

  xdg.mimeApps = {
    enable = true;
    # xdg-mime query filetype input.png
    # xdg-mime query default "image/*"

    # TODO:
    defaultApplications = {
      "x-scheme-handler/https" = ["google-chrome.desktop"];
      "x-scheme-handler/http" = ["google-chrome.desktop"];
      "x-scheme-handler/mailto" = ["google-chrome.desktop"];
      "text/html" = ["google-chrome.desktop"];
      "image/png" = ["org.gnome.eog.desktop"];
      "image/jpeg" = ["org.gnome.eog.desktop"];
      "image/tiff" = ["org.gnome.eog.desktop"];
    };
  };
}
