#!/bin/bash
SCRIPT_NAME=$0
function print_usage_and_exit {
  echo "Usage: $SCRIPT_NAME --clean-repos <optional argument to clean the repos folder> "
  exit 1
}
if [ "$1" = "--clean-repos" ];then
	rm -rf repos/
elif [ ! -z "$1" ];then
  print_usage_and_exit
fi

WORKING_DIR=`pwd`
CONFIG_DIR="$WORKING_DIR/config"
REPOS="$WORKING_DIR/repos"
REPO_LIST="$WORKING_DIR/repo-list.json"

if [ ! -d "$REPOS" ]; then
	mkdir $REPOS
fi
cd $REPOS

let SIZE=$(cat $REPO_LIST | jq -r '.repos | length')-1

for i in $(seq 0 1 $SIZE)
do
	NAME=$(cat $REPO_LIST | jq -r ".repos | .[$i].name")
	echo "Repo: $NAME"
	URL=$(cat $REPO_LIST | jq -r ".repos | .[$i].url")
	COMMIT=$(cat $REPO_LIST | jq -r ".repos | .[$i].commit")
	REGULAR=$(cat $REPO_LIST | jq -r ".repos |.[$i].status.regular")
	if [ "$REGULAR" = true ]; then
		if [ ! -d "$NAME" ]; then
			echo "cloning repo with $NAME."
			git clone $URL $NAME
			if [ ! -d "$NAME" ]; then
				echo "git failed to clone $REPO"
			else
				cd $NAME
				git reset --hard $COMMIT
				cd $REPOS
			fi
		fi
	else
		echo "non regular"
		cd $CONFIG_DIR
		$NAME/build.sh --name $NAME --url $URL --commit $COMMIT
		cd $REPOS
	fi
done

cd $WORKING_DIR
