#!/bin/sh

BASE_NAME="quarto"
PROJECT_NAME="bf-defprit"

R_RELEASE="4.2.1"
RSTUDIO_VERSION="2022.07.2+576"
PAPAJA_VERSION="0.1.1" # Eventually we should only accept releases here

NCPUS=1


# ------------------------------------------------------------------------------

TAG="$R_RELEASE-$(echo $PAPAJA_VERSION | grep -o "\w*$")-$(echo $RSTUDIO_VERSION | grep -o "^[0-9]*\.[0-9][0-9]")-$TEXLIVE_VERSION"
BASE_NAME="quarto:$TAG"
PROJECT_NAME="$PROJECT_NAME:$TAG"

docker build \
    --build-arg R_RELEASE=$R_RELEASE \
    --build-arg RSTUDIO_VERSION=$RSTUDIO_VERSION \
    --build-arg PAPAJA_VERSION=$PAPAJA_VERSION \
    --build-arg NCPUS=$NCPUS \
    --target quarto \
    -t $BASE_NAME .

docker build \
    --build-arg BASE_NAME=$BASE_NAME \
    --build-arg PROJECT_NAME=$PROJECT_NAME \
    --build-arg NCPUS=$NCPUS \
    --target project \
    -t $PROJECT_NAME .

# Add to work seamlessly with git inside the container
#
# Share global .gitconfig with container
#    --mount type=bind,src="/$HOME/.gitconfig",dst=/home/rstudio/.gitconfig,readonly \
#
# Share SSH credentials with container
#    --mount type=bind,src="/$HOME/.ssh",dst=/home/rstudio/.ssh,readonly \

if test ! -f DESCRIPTION ; then \
    Rscript -e "usethis::use_description(fields = list(Remotes = c('github::crsh/papaja@devel')), check_name = FALSE, roxygen = FALSE)"
fi

if test ! -f CITATION ; then \
    Rscript -e "usethis::use_template('citation-template.R', 'CITATION', data = usethis:::package_data(), open = TRUE)"
fi

Rscript -e "cffr::cff_write()"

docker run -d \
    -p 8787:8787 \
    -e DISABLE_AUTH=TRUE \
    -e ROOT=TRUE \
    --mount type=bind,src="/$PWD",dst=/home/rstudio \
    --mount type=bind,src="/$(Rscript -e 'cat(path.expand(usethis:::rstudio_config_path()))')",dst=/home/rstudio/.config/rstudio \
    --name $(echo $PROJECT_NAME | grep -o "^[a-zA-Z0-9]*") \
    --rm \
    $PROJECT_NAME

sleep 1

git web--browse http://localhost:8787
