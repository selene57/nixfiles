{ lib, stdenv, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenv.mkDerivation {
  version = "2021-09-29";
  pname = "sweetly-gtk-theme";

  src = fetchFromGitHub {
    owner = "selene57";
    repo = "sweetly-gtk-theme";
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
    description = "A flat material light gtk theme (C) 2020-2021 owl4ce.";
    homepage = "https://github.com/owl4ce/dotfiles";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.selene57 ];
  };
}
