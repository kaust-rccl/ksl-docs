#!/bin/bash
if [ -z ${2} ]; then
       MESSAGE="Update by $(git config --get user.name)"
else
       MESSAGE=${2}
fi


while getopts "cuh" options; do 
  case ${options} in
    h )
	   echo "Usage: [-h] [-c|-u] value]"
	   echo "c	Start a development environment for writing documentation"
	   echo "u	Update and push new code to github in dev branch. Please create a PR to upstream to main branch"

	   exit
      ;;
    c )
     echo " Creating the docker container for development"
     git pull origin dev
     if [ $(docker ps -aq -f 'name=ksl-docs') != "" ]; then 
       docker start $(docker ps -aq -f 'name=ksl-docs')
       docker exec -ti ksl-docs bash
     else
       docker run --name ksl-docs -ti -v ${PWD}:/workdir -w /workdir krccl/ksl-docs:latest
     fi 
     ;;
    u )
     echo "commiting and pushing codebase to GitHub in dev branch. Once done, please create a pull request on GitHub to upstream your changes to main branch"     
     git add ksl-docs/docs/source/*
     git commit -m $MESSAGE
     git push -u origin dev
     ;;
    \? ) echo "Usage: cmd [-h] [-v] [-b] [-p] [-m] [-t]"
	    exit
    ;;
    esac
done
shift $((OPTIND -1))