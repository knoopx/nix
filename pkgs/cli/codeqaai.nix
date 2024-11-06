{
  pkgs,
  stdenv,
  ...
}:
{
  python311.pkgs.buildPythonApplication {
    pname = "codeqai";
    version = "0.0.18";

    pyproject = true;

    nativeBuildInputs = [
      pkgs.python311Packages.poetry-core
    ];

    dependencies = with pkgs.python311Packages; [
      inquirer
      langchain-openai
      langchain-community
      openai
      python-dotenv
      pyyaml
      rich
      streamlit
      tiktoken
      tree-sitter
      tree-sitter-languages
      yaspin
    ];

    # build-system = [
    #   # requires = ["poetry-core"]
    #   # build-backend = "poetry.core.masonry.api"
    # ];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-yLf/QVUHa7c41wIiT/Y6rTBrBCha4QeWWqTiF/bYMvA=";
    };

    # format = "other";

    # src = fetchurl {
    #   url = "https://github.com/fynnfluegge/codeqai/archive/refs/tags/${version}.tar.gz";
    #   sha256 = "sha256-AboKuipHX/OFx8vAv4wFw3d5Gq7zjMNklYhc3/Akmck=";
    # };
    # By default tests are executed, but they need to be invoked differently for this package
    # dontUseSetuptoolsCheck = true;
  }
}