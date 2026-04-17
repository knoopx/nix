# Update pkgs/ and overlays/ to Latest Versions

Update all packages in `pkgs/` and `overlays/` to their latest versions from upstream repositories.

## Process

### 1. Identify packages with hardcoded versions

```bash
grep -rn 'version\s*=\s*"' pkgs/ overlays/ --include='*.nix'
grep -rn 'rev\s*=\s*"' pkgs/ overlays/ --include='*.nix'
```

### 2. Check for newer versions

**GitHub releases:**

```bash
gh api repos/OWNER/REPO/releases/latest | jq -r '.tag_name'
```

**GitHub branches (for unstable versions):**

```bash
# Always check the actual default branch name first — some use 'main', some 'master'
gh api repos/OWNER/REPO --jq '.default_branch'
gh api repos/OWNER/REPO/commits/main --jq '.sha'
```

### 3. Update and get hashes (iterative)

For packages exposed as flake outputs (`.#pkgname`), edit the file in place with blank hashes, then build:

**Step A: Set all hashes to empty string `""`**

```nix
# WRONG — causes 'invalid SRI hash' error (wrong base32 length)
hash = "sha256-";

# CORRECT — Nix substitutes a zero hash and reports the real one on build
hash = "";
```

Update version, rev, and set every hash field (`hash`, `cargoHash`, `vendorHash`) to `""`.

**Step B: Build and capture the first failing hash**

```bash
cd /home/knoopx/Projects/knoopx/nix
timeout 300 nix build .#pkgname --show-trace 2>&1 | grep 'got:'
```

Output looks like:

```
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-maf+Iu0NjJucM+XXUxa66xc3f9rGMQcxA9yEccKoCE0=
```

Fill in the source hash, rebuild. Then fill in `cargoHash` (Rust) or `vendorHash` (Go), rebuild again. One failure at a time — each build reveals only one missing hash.

For overlay packages not exposed as flake outputs (like helix), create a minimal test expression that applies the overlay and fetches the derivation:

```bash
cat > /tmp/test-helix.nix << 'EOF'
{pkgs ? import <nixpkgs> { overlays = [ (import /home/knoopx/Projects/knoopx/nix/overlays/helix.nix) ]; }}: pkgs.helix-unwrapped
EOF
timeout 300 nix-build /tmp/test-helix.nix 2>&1 | grep 'got:'
```

### 4. Verify the build completes successfully

```bash
cd /home/knoopx/Projects/knoopx/nix
nix build .#pkgname --no-link
ls -la result
```

## Common Patterns

### Rust packages

```nix
{pkgs, ...}: let
  pname = "pkgname";
  version = "X.Y.Z";
  src = pkgs.fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "v${version}";
    hash = "";   # blank — filled from build error
  };
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "";   # blank — filled from build error
  doCheck = false;
}
```

### Go packages

```nix
{pkgs, ...}: let
  pname = "pkgname";
  version = "X.Y.Z";
  src = pkgs.fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "v${version}";
    hash = "";   # blank — filled from build error
  };
in
pkgs.buildGoModule {
  inherit pname version src;
  vendorHash = "";   # blank — filled from build error
  subPackages = ["cmd/pkgname"];
}
```

### Overlay packages

Overlays that modify nixpkgs derivations:

```nix
final: prev: {
  helix-unwrapped = prev.helix-unwrapped.overrideAttrs (old: rec {
    version = "git";
    src = final.fetchFromGitHub {
      owner = "helix-editor";
      repo = "helix";
      rev = "<new-commit-sha>";
      hash = "";   # blank — filled from build error
    };
    patches = [];
    cargoDeps = final.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
    };
    doCheck = false;
    doInstallCheck = false;
    env = old.env // { HELIX_NIX_BUILD_REV = src.rev; };
  });
}
```

### Unstable versions

Use commit date in version for tracking:

```nix
version = "0-unstable-YYYY-MM-DD";
rev = "<commit-sha>";
```

## Tips

- **Always use `""` (empty string), never `"sha256-"`** — the latter causes an SRI validation error because it's not a valid base32 length. Nix treats `""` as a zero hash and reports the correct one on build.
- **Build iteratively, not all-at-once** — each build failure reveals only one hash. Fix source hash first, rebuild, then fix cargo/vendor hash on the next run.
- **Edit the actual package file in place** rather than copying logic into a test.nix — this preserves all build context (nativeBuildInputs, buildInputs, postPatch, etc.) and avoids duplication. Only use a test.nix when the overlay isn't exposed as a flake output.
- **Use `timeout` for builds** — Rust packages can take a long time to compile. Use `timeout 300` as a sanity check before committing to a full build.
- **For overlay packages not exposed as flake outputs**, create a minimal test.nix that imports the overlay and fetches the derivation, then build with blank hash and capture the `got:` output. Do NOT use `nix-prefetch-url` — its output is not in Nix-compatible SRI format.
- **Always verify the build succeeds** after filling all hashes — a passing hash check doesn't mean the derivation builds correctly.
- **Keep the flake updated**: `nix flake update`
