let
  kapack = import
    ( fetchTarball "https://github.com/oar-team/nur-kapack/archive/master.tar.gz") {};
  my_batsched = kapack.batsched.overrideAttrs (attr: rec {
      name = "batsched-with-modified-conservative-bf";
      src = ./pybatsim-core;
    });
#    r tools around Batsim
#    battools_r = kapack.pkgs.rPackages.buildRPackage {
#      name = "battools-r-fcccf8a";
#      src = fetchgit {
#        url = "https://framagit.org/batsim/battools.git";
#        rev = "fcccf8a6bccae388af6a17b866bba6c11097734f";
#        sha256 = "05vll6rhdiyg38in8yl0nc1353fz2j7vqpax64czbzzhwm5d5kfs";
#      };
#      propagatedBuildInputs = with kapack.pkgs.rPackages; [
#        dplyr
#        readr
#        magrittr
#        assertthat
#      ];
#    };
 #   battools_r=import( fetchGit {url="https://framagit.org/batsim/battools.git"; ref="master";}); 
in

kapack.pkgs.mkShell rec {
  name = "tuto-env";
  buildInputs = [
    kapack.batsim # simulator
    my_batsched # <===== your scheduler
    kapack.batexpe # experiment management tools
#   battools_r
  ];
}
