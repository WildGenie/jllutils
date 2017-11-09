#!/bin/bash
# Copyright(c) 2016-2100.  root.  All rights reserved.
#
#   FileName:     
#   Author:       root
#   Email:        493164984@qq.com
#   DateTime:     2017-11-01 21:11:31
#   ModifiedTime: 2017-11-09 11:48:17

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

function Reachxm_L170H_on_mdm9607_by_jllim()
{
    jllProject="L170H"  #
    jllRoot="/media/root/work/mdm9607/mangov2/trunk_yxlog/apps_proc"

    #####################################################################

    JLLPATH="$(which jll.god.sh)"
    JLLPATH="$(dirname ${JLLPATH})"
    if [ ! -e "${JLLPATH}/BashShellLibrary" ]; then
        echo
        echo -e "[0m[31mjllim: Error - not found BashShellLibrary[0m"
        echo
        exit 0
    fi
    source ${JLLPATH}/BashShellLibrary

    declare -a GvMenuUtilsContent=(
        "CodeTree: Enter"
        "Kernel:   Build"
        "Kernel:   Flash"
        "Usage:    Help Information"
    )
    GvMenuUtilsContentCnt=${#GvMenuUtilsContent[@]}

    while [ 1 -eq 1 ]; do
        Lfn_MenuUtils GvResult  "Select" 7 4 \
            "***** ${jllProject} Main MENU (q: quit no matter what) *****"
        GvResultID=0

        # "CodeTree: Enter"
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
            clear
            [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
            [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
            echo

            declare -a GvMenuUtilsContent=(
                "kernel path"
                "mcm-api path"
                "build path"
                "images path"
            )
            GvMenuUtilsContentCnt=${#GvMenuUtilsContent[@]}
            Lfn_MenuUtils GvResult  "Select" 7 4 \
                "***** ${jllProject} CodeTree MENU (q: quit no matter what) *****"
            GvResultID=0
            #kernel path
            if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
                clear
                [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
                [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
                jllTarget="${jllRoot}/kernel/msm-3.18"
                if [ -e "${jllTarget}" ]; then
                    cd ${jllTarget}
                else
                    echo -e "Not found ${Fred}${jllTarget}${AC}"
                fi
                break 
            fi
            #mcm-api path
            if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
                clear
                [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
                [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
                jllTarget="${jllRoot}/mcm-api"
                if [ -e "${jllTarget}" ]; then
                    cd ${jllTarget}
                else
                    echo -e "Not found ${Fred}${jllTarget}${AC}"
                fi
                break 
            fi
            #build path
            if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
                clear
                [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
                [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
                jllTarget="${jllRoot}/poky"
                if [ -e "${jllTarget}" ]; then
                    cd ${jllTarget}
                else
                    echo -e "Not found ${Fred}${jllTarget}${AC}"
                fi
                break 
            fi
            #images path
            if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
                clear
                [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
                [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
                jllTarget="${jllRoot}/poky/build/tmp-glibc/deploy/images"
                if [ -e "${jllTarget}" ]; then
                    cd ${jllTarget}
                else
                    echo -e "Not found ${Fred}${jllTarget}${AC}"
                fi
                break 
            fi
            echo
            break; 
        fi
        #"Kernel:   Build"
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
            clear
            [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
            [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
            echo
            if [ ! -e "${jllRoot}/poky/build/conf/set_bb_env_${jllProject}.sh" ]; then
                echo -e \
                "JLLim: Not found ${Fred}${jllRoot}/poky/build/conf/set_bb_env_${jllProject}.sh${AC}"
                break;
            fi
            cd ${jllRoot}/poky
            source build/conf/set_bb_env_${jllProject}.sh
            mbuild linux-quic
            echo
            break;
        fi

        #"Kernel:   Flash"
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
            clear
            [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
            [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
            echo
            if [ ! -e "${jllRoot}/poky/build/tmp-glibc/deploy/images/mdm9607/mdm9607-boot.img" ];
            then
                echo -e \
                "JLLim: Not found ${Fred}${jllRoot}/poky/build/tmp-glibc/deploy/images/mdm9607/mdm9607-boot.img"
                break;
            fi
            adb reboot-bootloader
            fastboot devices
            fastboot flash boot mdm9607-boot.img
            fastboot reboot 
            echo
            break;
        fi


    done
    [ x"${GvMenuUtilsContent}" != x ] && unset GvMenuUtilsContent
    [ x"${GvMenuUtilsContentCnt}" != x ] && unset GvMenuUtilsContentCnt
}
export -f reachxm_xghd_on_mdm9607_by_jllim
