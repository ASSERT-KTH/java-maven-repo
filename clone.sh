#!/bin/bash

WORKING_DIR=`pwd`
REPOS="$WORKING_DIR/repos"
REPO_LIST="$WORKING_DIR/repo-list.json"

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
			echo "$NAME does not exist."
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
		cd $WORKING_DIR
		config/$NAME/build.sh --name $NAME --url $URL --commit $COMMIT
		cd $REPOS
	fi
done

cd $WORKING_DIR
