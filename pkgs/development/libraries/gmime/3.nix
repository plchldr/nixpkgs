{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.2.1";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.2/${name}.tar.xz";
    sha256 = "0q65nalxzpyjg37gdlpj9v6028wp0qx47z96q0ff6znw217nzzjn";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ gobjectIntrospection zlib gpgme libidn2 libunistring ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
  configureFlags = [ "--enable-introspection=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  '';

  checkInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jstedfast/gmime/;
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chaoflow ];
    platforms = platforms.unix;
  };
}
