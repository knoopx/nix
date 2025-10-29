self: super: {
  firefox = super.firefox.overrideAttrs (oldAttrs: {
    disallowedRequisites = [];
  });
}