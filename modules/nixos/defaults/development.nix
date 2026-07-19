{ lib, ... }:
with lib; {
  options.defaults.development = {
    javascript = mkOption {
      type = types.bool;
      description = "Enable JavaScript/TypeScript development packages";
      default = true;
    };
    python = mkOption {
      type = types.bool;
      description = "Enable Python development packages";
      default = true;
    };
    nix = mkOption {
      type = types.bool;
      description = "Enable Nix development packages";
      default = true;
    };
    rust = mkOption {
      type = types.bool;
      description = "Enable Rust development packages";
      default = true;
    };
    ruby = mkOption {
      type = types.bool;
      description = "Enable Ruby development packages";
      default = false;
    };
    crystal = mkOption {
      type = types.bool;
      description = "Enable Crystal development packages";
      default = false;
    };
    go = mkOption {
      type = types.bool;
      description = "Enable Go development packages";
      default = false;
    };
    system = mkOption {
      type = types.bool;
      description = "Enable general system development packages";
      default = true;
    };
  };

  imports = [
    ../packages/dev/crystal.nix
    ../packages/dev/go.nix
    ../packages/dev/javascript.nix
    ../packages/dev/nix.nix
    ../packages/dev/python.nix
    ../packages/dev/ruby.nix
    ../packages/dev/rust.nix
    ../packages/dev/system.nix
  ];
}
