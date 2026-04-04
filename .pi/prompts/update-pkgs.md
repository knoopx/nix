# Update pkgs/ to Latest Versions

Update all packages in `pkgs/` to their latest versions from upstream repositories.

## Process

### 1. Identify packages with hardcoded versions

List all `.nix` files in `pkgs/` and identify which ones have version pins:

```bash
ls -la pkgs/
```

Check each file for `version =` or `rev =` fields.

### 2. Check for newer versions

For each package, check the latest version from its source:

**GitHub releases:**

```bash
gh api repos/OWNER/REPO/releases/latest | jq -r '.tag_name'
```

**GitHub branches (for unstable versions):**

```bash
gh api repos/OWNER/REPO/branches/main | jq -r '.commit.sha'
```

**Codeberg (for GramEditor/gram):**

```bash
curl -s https://codeberg.org/GramEditor/gram/releases | grep -oP 'releases/download/\K[0-9.]+' | head -1
```

### 3. Fetch new hashes

Download the new source and compute the hash:

```bash
# Download source
curl -sL https://github.com/OWNER/REPO/archive/REV.tar.gz -o source.tar.gz

# Get SHA256 hash
sha256sum source.tar.gz | awk '{print $1}'

# Convert base16 to SRI format
nix hash convert --hash-algo sha256 --from base16 --to sri <base16-hash>
```

### 4. Build to get vendor/cargo hashes

Create a test build file and run it to get the correct vendor/cargo hashes:

```bash
cat > /tmp/test.nix << 'EOF'
{pkgs ? import <nixpkgs> {}}:
let
  pname = "pkgname";
  version = "X.Y.Z";
  src = pkgs.fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "v${version}";
    hash = "sha256-<NEW-SRC-HASH>";
  };
in
pkgs.buildGoModule {  # or rustPlatform.buildRustPackage
  inherit pname version src;
  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # placeholder
  # ... rest of build
}
EOF

nix-build /tmp/test.nix 2>&1 | grep 'got:' | awk '{print $2}'
```

The "got:" hash is the correct hash to use.

### 5. Update the nix file

Replace version, rev, and all hashes in the package file:

```nix
{pkgs, ...}: let
  pname = "pkgname";
  version = "NEW_VERSION";  # Updated

  src = pkgs.fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "NEW_REV";         # Updated
    hash = "sha256-NEW_HASH"; # Updated
  };
in
  pkgs.buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-NEW_VENDOR_HASH";  # Updated from build error

    # ... rest unchanged
  }
```

### 6. Verify build

```bash
cd /home/knoopx/Projects/knoopx/nix
nix build .#pkgname
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
    hash = "sha256-...";
  };
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-...";  # Get from build error
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
    hash = "sha256-...";
  };
in
pkgs.buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-...";  # Get from build error
  subPackages = ["cmd/pkgname"];
}
```

### Unstable versions

Use commit date in version for tracking:

```nix
version = "0-unstable-YYYY-MM-DD";
rev = "<commit-sha>";
```

## Tips

- Always use `{pkgs, ...}` instead of `{pkgs}` for haumea compatibility
- The first build will fail with hash mismatches - use the "got:" hashes
- Test builds can be slow; use `timeout` if needed
- Keep the flake updated: `nix flake update`
