# java-maven-repo
List of github repo using maven as build tool.


## Prerequisites
- Docker
- bash
- (jq)[https://stedolan.github.io/jq/]

## How to use
Building the base image
```
docker build -t maven-non-root .
```

Cloning repos
```
./clone.sh
```

Run your exp
```
docker run -it -v /path/to/repos:/repos maven-mod /bin/bash -v /path/to/.m2:/home/maven/.m2 -c "./run-your-exp.sh"
```
