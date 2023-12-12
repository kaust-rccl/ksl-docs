#!/bin/bash
if [ -z "${2}" ]; then
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
     module use /sw/tools/modulefiles
     module load ksldocs
     git pull origin dev
     git checkout dev
     singularity shell -B ${PWD}:/workdir:rw --pwd /workdir/docs $IMAGE 
     ;;
    u )
     echo "commiting and pushing codebase to GitHub in dev branch. Once done, please create a pull request on GitHub to upstream your changes to main branch"     
     git checkout dev
     git add docs/source/*
     git commit -m "${MESSAGE}"
     git push -u origin dev
     ;;
    \? ) echo "Usage: cmd [-h] [-v] [-b] [-p] [-m] [-t]"
	    exit
    ;;
    esac
done
shift $((OPTIND -1))