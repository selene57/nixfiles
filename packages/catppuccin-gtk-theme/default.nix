{ lib, stdenvNoCC, fetchFromGitHub, git, sassc, gtk3, gnome-themes-extra, gtk-engine-murrine }:

stdenvNoCC.mkDerivation rec {
  version = "unstable-2021-02-01";
  pname = "catppuccin-gtk-theme";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    rev = "a23d6fc7061d0d10f4b45c2751b4386c89bb02a0";
    sha256 = "ly8SuUA34F1ZJonXNHPLS3OUkqJwidR4AnWhDLb51Yw=";
  };

  nativeBuildInputs = [ 
    sassc
    gtk3
    git
  ];
  
  buildInputs = [
    gnome-themes-extra
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/Catppuccine
    cp -a {./src/assets} $out/share/themes/Catppuccine
    runHook postInstall
   '';

  meta = with lib; {
    description = "GTK theme for catppuccin. Warm dark theme for the masses";
    homepage = "https://github.com/catppuccin/gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.selene57 ];
  };
}
