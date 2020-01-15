#!/bin/bash
# script to get a hugo docker set up with the whole documentation page 
# with your local repos documentation stuff mounted inside

REPO_NAME=$(basename `git rev-parse --show-toplevel`)
# we assume the push and fetch is the same so just get the fetch
GIT_REMOTE=$(git remote -v | head -n 1)
# pattern for matching with orgs like dolittle-tools/DotNET.Build etc
DASH_PATTERN='.*dolittle-(\w+)\/(\S+)\.git.*'
# pattern for finding repos like dolittle/Documentation etc
PATTERN='.*dolittle\/\S+\.git.*'

if [[ $GIT_REMOTE =~ $DASH_PATTERN ]] ; then
    # combine ORG_NAME with REPO_NAME to get the wanted structure for hugo.
    # check the structure from repo dolittle/Documentation, inside /Source/repositories
    ORG_PATH=$(echo $GIT_REMOTE | sed -E "s/$DASH_PATTERN/\1/g" | tr '[:upper:]' '[:lower:]')
    ORG_PATH=$ORG_PATH/$REPO_NAME
elif [[ $GIT_REMOTE =~ $PATTERN ]] ; then
    # ORG_PATH is the same as REPO_NAME but lowercase
    ORG_PATH=$(echo $REPO_NAME | tr '[:upper:]' '[:lower:]')
else
    echo "Error: not a Dolittle repository"
    echo $GIT_REMOTE
    exit 1
fi

# get the absolute path to your local repos root
GIT_ROOT=$(git rev-parse --show-toplevel)
MOUNT_CMD="$GIT_ROOT:/Documentation/Source/repositories/$ORG_PATH"
# mount your local project root inside the Source/repositories/ path
docker run -it -p 1313:1313 -v $MOUNT_CMD dolittle/documentation

