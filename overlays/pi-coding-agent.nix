final: prev:
let
  # The knoopx fork's pi-coding-agent changes as a single git compare patch
  # (v0.85.1...knoopx:pi-coding-agent:main). Fetched at eval time so the patch
  # body is not inlined into this overlay. `name` is required: the URL-derived
  # store path would otherwise contain the illegal ':' character.
  piPatch = final.fetchurl {
    url = "https://github.com/earendil-works/pi/compare/v0.85.1...knoopx:pi-coding-agent:main.patch";
    name = "pi-coding-agent-patch";
    sha256 = "sha256-GjJ/gosdO0+4+V9TAkXGDWBdUN6dZnUBvFhKQ82VsQA=";
  };
in
{
  # Apply the fork's changes at the source level (stdenv `patches`), i.e. the
  # compare patch is applied to the unpacked v0.85.1 monorepo tree before the
  # tsgo build runs, instead of patching the installed $out later.
  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ piPatch ];
  });
}
