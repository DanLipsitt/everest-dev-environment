{ pkgs, lib, config, inputs, ... }:

let
  initial-requirements = builtins.replaceStrings ["\n"] [" "] ''
    -e ./dependency_manager
    -r ./workspace/Josev/requirements.txt
  '';
in {
  env = {};

  # https://devenv.sh/packages/
  packages = [
    pkgs.git

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
    pkgs.util-linux
    pkgs.libcap
  ];

  scripts = {
    init-workspace = {
      description = "Initialize workspace";
      exec = ''
        pip install -e ./workspace/everest-utils/ev-dev-tools
        edm init --workspace workspace
      '';
    };
    init-deps = {
      exec = ''
        pip install ${initial-requirements}
      '';
    };
  };

  enterShell = ''
    if [ ! -d workspace ]; then
      init-workspace
      init-deps
    fi
    # set CPM_SOURCE_CACHE using the xdgappdirs python package if not set
    if [ -z ''${CPM_SOURCE_CACHE} ]; then
      CPM_SOURCE_CACHE=$(python -c 'import xdgappdirs; print(xdgappdirs.user_cache_dir("cpm_source_cache"))')
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
      requirements = ''
        xdgappdirs
      '';
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
