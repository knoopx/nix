{
  lib,
  nixosConfig,
  ...
}: {
  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      name = nixosConfig.defaults.fullName;
      email = nixosConfig.defaults.primaryEmail;
    };
    ui = {
      editor = lib.getExe nixosConfig.defaults.apps.editor.package;
      merge-editor = "weave";
    };
    "merge-tools" = {
      weave = {
        program = "weave-driver";
        merge-args = ["$base" "$left" "$right" "-o" "$output" "-l" "$marker_length" "-p" "$path"];
        merge-conflict-exit-codes = [1];
        merge-tool-edits-conflict-markers = true;
        conflict-marker-style = "git";
      };
    };
  };
}
