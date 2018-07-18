#!/bin/bash
#Here goes the script to build the
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

#setting up variables
CONFIG_DIR=`pwd`
REPOS="$CONFIG_DIR/../repos"

XWIKI_COMMONS_COMMIT="790c587"
XWIKI_COMMONS_NAME="xwiki-commons"
XWIKI_COMMONS_URL="https://github.com/xwiki/xwiki-commons.git"
#checking first if xwiki-commons exist
if [ ! -d "$REPOS/$XWIKI_COMMONS_NAME" ];then
  git clone $XWIKI_COMMONS_URL $XWIKI_COMMONS_NAME
  if [! -d "$XWIKI_COMMONS_NAME" ];then
    echo "could not clone the repository $XWIKI_COMMONS_NAME"
    exit 1
  fi
  cd $XWIKI_COMMONS_NAME
  mvn package
fi
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
