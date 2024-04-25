{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "xdgappdirs";
  version = "1.4.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/a+phbj6dg6Rj8nRVC/1xYLZrbmnmHXEMp9mLExDXq8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "xdgappdirs" ];

  meta = with lib; {
    description = "A small Python module for determining appropriate platform-specific dirs, e.g. a \"user data dir";
    homepage = "https://pypi.org/project/xdgappdirs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
