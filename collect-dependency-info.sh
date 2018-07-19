#!/bin/bash

WORKING_DIR=`pwd`
REPOS="$WORKING_DIR/repos"

cd $REPOS

for project in `ls -d *`
do
	echo "Project: $project"	
	cd $project
	mvn install -Dmaven.test.skip=true
	mvn dependency:list | grep "    .*:.*:.*:.*" | cut -d] -f2- | sort | uniq > dependency.list
	cd ..
done
