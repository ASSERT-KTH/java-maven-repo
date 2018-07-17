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
	if [ ! -d "$NAME" ]; then
		echo "$NAME does not exist."
		git clone $URL
		if [ ! -d "$NAME" ]; then
			echo "git failed to clone $REPO"
		else
			cd $NAME
			git reset --hard $COMMIT
			cd $REPOS
		fi
	fi
done

cd $WORKING_DIR
