{pkgs, ...}: let
  playwright-browsers = pkgs.playwright-driver.browsers.override {
    withFirefox = true;
    withChromium = false;
    withWebkit = false;
    withFfmpeg = false;
    withChromiumHeadlessShell = true;
  };
in {
  environment = {
    variables = {
      PLAYWRIGHT_BROWSERS_PATH = playwright-browsers;
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    };
  };
}
