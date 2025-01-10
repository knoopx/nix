{pkgs, ...}: let
  name = "wiki";
  root = "/mnt/storage/silverbullet";
  public-url = "https://${name}.knoopx.net";
in {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "sb" ''
      pushd ${root}
      fd --type f -e md . | grep -v Library/Core | grep -v Templates | awk '{print substr($0, 1, length($0)-3) "\t" $0}' | sort --ignore-case | fzf --reverse --with-nth=1 --preview-window=right:70% \
          --delimiter='\t' \
          --preview 'glow --style=dark {2}' \
          --bind="enter:execute(sb-open {2})"
      popd
    '')

    (writeShellScriptBin "sb-open" ''
      # set -l base_url "${public-url}"
      # set -l url_path (echo $path | sed 's/\.md$//' | sed 's/ /%20/g')
      # xdg-open "$base_url/$url_path"
      ${pkgs.micro}/bin/micro $1
    '')
  ];

  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "zefhemel/silverbullet";
      environmentFiles = ["${root}/.env"];
      volumes = [
        "${root}:/space"
      ];
    };
  };
}
