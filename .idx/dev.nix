{ pkgs, ... }: {
  channel = "unstable";
  # channel = "stable-23.11";
  packages = [
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.jupyter
    pkgs.R

    # Build R
    pkgs.gcc
    pkgs.gfortran
    pkgs.gnumake
    pkgs.pkg-config

    # R helper
    pkgs.libxml2.dev
    pkgs.openssl.dev
    pkgs.zlib.dev
    pkgs.curl.dev
    pkgs.fontconfig.dev
    pkgs.freetype.dev
    pkgs.fribidi.dev
    pkgs.harfbuzz.dev
    pkgs.libpng.dev
    pkgs.libtiff.dev
    pkgs.libjpeg.dev
  ];

  env = {
    PKG_CONFIG_PATH = "${pkgs.libxml2.dev}/lib/pkgconfig:${pkgs.freetype.dev}/lib/pkgconfig:${pkgs.harfbuzz.dev}/lib/pkgconfig:${pkgs.fribidi.dev}/lib/pkgconfig:${pkgs.fontconfig.dev}/lib/pkgconfig:${pkgs.libpng.dev}/lib/pkgconfig:${pkgs.libtiff.dev}/lib/pkgconfig:${pkgs.libjpeg.dev}/lib/pkgconfig";
    R_LIBS_USER = "/home/user/R/x86_64-pc-linux-gnu-library/4.4";
  };
  idx = {
    extensions = [
      "ms-toolsai.jupyter"
      "ms-python.python"
      "ms-python.debugpy"
      "ms-toolsai.jupyter-keymap"
      "ms-toolsai.jupyter-renderers"
      "ms-toolsai.vscode-jupyter-cell-tags"
      "ms-toolsai.vscode-jupyter-slideshow"
      "REditorSupport.r"
    ];

    workspace = {
      onCreate = {
        init = ''
          # Set up Python virtual environment
          python -m venv .venv
          source .venv/bin/activate
          pip install -r requirements.txt

          mkdir -p /home/user/R/x86_64-pc-linux-gnu-library/4.4
          rm -rf /home/user/R/x86_64-pc-linux-gnu-library/4.4/00LOCK-*

          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
            install.packages('languageserver', repos='https://cran.r-project.org/')
          "

          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
            install.packages('MASS', dependencies = TRUE, repos='https://cran.r-project.org/')
          "

          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
            install.packages('tidyverse', dependencies = TRUE, repos='https://cran.r-project.org/')
          "

          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
            install.packages('juicyjuice', repos='https://cran.r-project.org/')
          "

          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
            install.packages('patchwork', dependencies = TRUE, repos='https://cran.r-project.org/')
          "

          # Install required R packages
          R --silent --slave --no-save --no-restore -e "
            .libPaths('/home/user/R/x86_64-pc-linux-gnu-library/4.4')
          required_packages <- c(
            'IRkernel', 'devtools', 
            'viridis', 'circlize', 'RColorBrewer'
          )

          installed_packages <- rownames(installed.packages())
          to_install <- setdiff(required_packages, installed_packages)

          if (length(to_install) > 0) {
            install.packages(to_install, dependencies = TRUE, repos = 'https://cran.r-project.org/')
          }
          IRkernel::installspec(user = TRUE)
          "
        '';

        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "ScholarScraper_output.ipynb" ];
      };
    };

    # Enable previews and customize configuration
    previews = {};
  };
}


# /nix/store/v2ngdlg7hy5bmk9las1w9hfd4dnhshhb-init