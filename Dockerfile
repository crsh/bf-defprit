# Select base image
ARG R_RELEASE="4.2.1"
ARG BASE_NAME="quarto"

FROM rocker/rstudio:${R_RELEASE} AS quarto

# System libraries
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libgsl0-dev \
    libnlopt-dev \
    libxt6 \
    ssh \
    fonts-firacode \
    libxml2 \
    libglpk-dev

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.1.251/quarto-1.1.251-linux-amd64.deb
RUN sudo apt-get install ./quarto-1.1.251-linux-amd64.deb

# Setup R packages
ARG NCPUS=1
RUN install2.r --error \
    --skipinstalled \
    --ncpus $NCPUS \
    tinytex \
    remotes \
    markdown \
    mime

FROM ${BASE_NAME} as project

# Install packages specified in DESCRIPTION
COPY DESCRIPTION* /home/rstudio/
WORKDIR /home/rstudio/

RUN if test -f DESCRIPTION ; then \
        install2.r --error \
        --skipinstalled \
        $(Rscript -e "pkg <- remotes:::load_pkg_description('.'); repos <- c('https://cloud.r-project.org', remotes:::parse_additional_repositories(pkg)); deps <- remotes:::local_package_deps(pkgdir = '.', dependencies = NA); write(paste0(deps, collapse = ' '), stdout())"); \
    fi

RUN rm -f DESCRIPTION
RUN rm -rf /tmp/downloaded_packages
RUN mkdir -p .config/rstudio
