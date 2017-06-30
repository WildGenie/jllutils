#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLFILE="$(which $0)"
JLLFILE="$(basename $0)"
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

GvDate=$(date +%Y%m%d%H%M%S)


function Fn_Usage()
{
cat >&1 <<EOF

  Usage:

      # Hint how to use 
      ${JLLFILE} [help]

      # initialize every git repositories via git clone according to .repoconf 
      ${JLLFILE} init

      # repo sync from remote git repository,
      # equals to repo forall -c 'git reset --hard HEAD;git clean -dfx;git pull -u origin master'
      ${JLLFILE} sync 

      # traversal every git repositories to run the speicified command
      ${JLLFILE} forall -c '<YOUR_COMMAND>'  

EOF
}
echo

if [ x"$(ls .git 2>/dev/null)" = x ]; then
    echo
    echo "Exit: not a git repository (or any of the parent directories): .git"
    echo
    exit 0
fi



git status -s
git pull origin master
git log --pretty=format:'%Cred%h%Creset  %Cgreen%ce%Creset %Cblue(%cr)%Creset  %C(yellow)%s%Creset' -8

