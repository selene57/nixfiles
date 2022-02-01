{ lib, stdenv, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenv.mkDerivation {
  version = "2021-1-31";
  pname = "levuaska-gtk-theme";

  src = fetchFromGitHub {
    owner = "selene57";
    repo = "levuaska-gtk-theme";
    rev = "a7d90739aa157f87d40163d555bb24716558158a";
    sha256 = "7UNqXc5uzyzYHMt4lHPnMRkf+YnwuPMPiP1YnARkVU8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk_engines ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "A flat material dark gtk theme by saimoomedits inspired by owl4ce's fleon theme.";
    homepage = "https://github.com/saimoomedits/levuaska";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonvandel maintainers.romildo ];
  };
}
