{ pkgs, lib, config, inputs, ... }:

let
  # build the xdgappdirs package from pip
  xdgappdirs = pkgs.python311Packages.buildPythonPackage rec {

    pname = "xdgappdirs";
    version = "1.4.5";
      format = "wheel";

    src = pkgs.fetchPypi {
      inherit pname version format;
      # python = "py2.py3";
      # dist = python;
      # platform = "any";
      sha256 = "sha256-j6S0cwSd5brdMdyYhhzxavbP8oG1F46ZdVVivLXwzYg=";
    };

    # The "native" dependency isn't used by the package, it's just used during
    # the build process to create the Python package.
    # nativeBuildInputs = with pkgs; [
    #   python3.pkgs.wrapPython
    # ];

    # We need the python interpreter to build the package.
    #pythonImportsCheck = [ "xdgappdirs" ];
  };
  in
{
  env = {};

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    xdgappdirs
  ];

  enterShell = ''
    # set CPM_SOURCE_CACHE using the xdgappdirs python package if not set
    if [ -z ''${CPM_SOURCE_CACHE} ]; then
      CPM_SOURCE_CACHE=<(python -c 'import xdgappdirs; print(xdgappdirs.user_cache_dir())')
    fi
    export CPM_SOURCE_CACHE
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/languages/
  languages.python.enable = true;
  languages.cplusplus.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
