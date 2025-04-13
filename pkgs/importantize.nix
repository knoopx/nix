{pkgs, ...}: let
  script = pkgs.writeTextFile {
    name = "importantize.js";
    executable = true;
    text = ''
      const postcss = require('postcss');

      const importantPlugin = (options = {}) => {
        return {
          postcssPlugin: 'postcss-important',
          Declaration(decl) {
            decl.important = true;
          }
        };
      };
      importantPlugin.postcss = true;

      let css = "";
      process.stdin.setEncoding('utf8');

      process.stdin.on('data', (chunk) => {
        css += chunk;
      });

      process.stdin.on('end', () => {
        postcss([importantPlugin()])
          .process(css, { from: undefined })
          .then(result => {
            process.stdout.write(result.css);
          })
          .catch(error => {
            console.error('Error processing CSS:', error);
            process.exit(1);
          });
      });

      process.stdin.on('error', (err) => {
        console.error('Error reading from stdin:', err);
        process.exit(1);
      });
    '';
  };
in
  pkgs.writeShellApplication {
    name = "importantize";
    runtimeInputs = with pkgs; [nodejs nodePackages.postcss];
    text = ''
      export NODE_PATH="${pkgs.nodePackages.postcss}/lib/node_modules"
      node ${script} "$@"
    '';
  }
