{ pkgs, lib, config, inputs, ... }:

let
  xdgappdirs = pkgs.python311Packages.buildPythonPackage rec {
    pname = "xdgappdirs";
    version = "1.4.5";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit pname version format;
      sha256 = "sha256-j6S0cwSd5brdMdyYhhzxavbP8oG1F46ZdVVivLXwzYg=";
    };
  };
  in
{
  env = {};

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    xdgappdirs

    pkgs.rsync
    pkgs.wget
    pkgs.doxygen
    pkgs.graphviz
    pkgs.cppcheck
    pkgs.boost
    pkgs.openssl
    pkgs.sqlite
    pkgs.curl
    pkgs.libpcap
    pkgs.libevent
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.libcap
  ];

  enterShell = ''
    # set CPM_SOURCE_CACHE using the xdgappdirs python package if not set
    if [ -z ''${CPM_SOURCE_CACHE} ]; then
      CPM_SOURCE_CACHE=$(python -c 'import xdgappdirs; print(xdgappdirs.user_cache_dir())')
    fi
    export CPM_SOURCE_CACHE
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/languages/
  languages.python = {
    enable = true;
    venv = {
      enable = true;
      requirements = (
        "./dependency_manager\n" +
        "./workspace/everest-utils/ev-dev-tools\n" +
        lib.readFile ./workspace/Josev/requirements.txt +
        lib.readFile dependency_manager/requirements.txt
      );
    };
  };
  languages.cplusplus.enable = true;
  languages.javascript.enable = true;
  languages.java = {
    enable = true;
    jdk.package = pkgs.openjdk;
  };

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
