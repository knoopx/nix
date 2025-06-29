{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    languages = {
      language-server = {
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = ["--stdio"];
          config = {};
        };

        solargraph.config = {
          diagnostics = true;
          formatting = true;
        };

        typescript-language-server = {
          command = lib.getExe pkgs.typescript-language-server;
          args = ["--stdio"];
          config = {};
        };
      };
      language = [
        {
          name = "python";
          language-servers = ["pyright"];
        }
        {
          name = "ruby";
          language-servers = ["solargraph"];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixpkgs-fmt";
        }

        {
          name = "toml";
          auto-format = true;
        }

        {
          name = "javascript";
          language-servers = ["typescript-language-server"];
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server"];
        }
      ];
    };

    settings = {
      editor.color-modes = true;
      editor.idle-timeout = 100;
      editor.soft-wrap.enable = true;
      editor.true-color = true;

      editor = {
        scrolloff = 10;

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 0;
        };

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {cursor-line = "error";};
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };
  };
}
