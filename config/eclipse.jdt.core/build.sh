#!/bin/bash
SCRIPT_NAME=$0
function print_usage_and_exit {
  echo "Usage: $SCRIPT_NAME --name <repository name> --url <repository url> --commit <desired commit>"
  exit 1
}

while [[ $# > 1 ]]
do
key="$1"
shift
case $key in
    --name)
    NAME="$1"
    shift
    ;;
    --commit)
    COMMIT="$1"
    shift
    ;;
    --url)
    URL="$1"
    shift
    ;;
    *)
    print_usage_and_exit
    ;;
esac
done

if [ -z $NAME ] || [ -z $COMMIT ] || [ -z $URL ];
then
    print_usage_and_exit
fi

CONFIG_DIR=`pwd`

REPOS="$CONFIG_DIR/../repos"
ECLIPSE_RELENG_COMMIT="d67663c"
ECLIPSE_RELENG_NAME="eclipse.platform.releng.aggregator"
ECLIPSE_RELENG_URL="https://github.com/eclipse/eclipse.platform.releng.aggregator"
cd $CONFIG_DIR/$NAME
#Building the dependencies (the aggregator project)
if [ ! -d "$ECLIPSE_RELENG_NAME" ]; then
  echo "cloning repo with name $ECLIPSE_RELENG_NAME."
  git clone $ECLIPSE_RELENG_URL $ECLIPSE_RELENG_NAME
  if [ ! -d "$ECLIPSE_RELENG_NAME" ]; then
    echo "git failed to clone $ECLIPSE_RELENG_NAME"
  else
    cd $ECLIPSE_RELENG_NAME
    git reset --hard $ECLIPSE_RELENG_COMMIT
    cd eclipse.platform.releng.prereqs.sdk
    mvn clean install
    #Building the jdt.core.
    cd $REPOS
    if [ ! -d "$NAME" ]; then
      git clone $URL $NAME
    fi
    if [ ! -d "$NAME" ]; then
      echo "Could not clone repository $NAME"
      exit 1
    fi
    cd $NAME
    git reset --hard $COMMIT
    cp -rf $CONFIG_DIR/$NAME/pom.xml .
  fi
fi
