#!/bin/bash
# Copyright(c) 2016-2100.  root.  All rights reserved.
#
#   FileName:     jll.ReachxmEnv_build.sh
#   Author:       root
#   Email:        493164984@qq.com
#   DateTime:     2017-11-01 21:11:31
#   ModifiedTime: 2017-11-01 21:15:42

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

if [ -e "/media/root/work/mdm9607/mangov2/trunk_yxlog/apps_proc/poky" ]; then
    cd /media/root/work/mdm9607/mangov2/trunk_yxlog/apps_proc/poky 
     
fi

