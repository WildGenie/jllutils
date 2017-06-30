#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
# ./xxx.sh
# ~/xxx.sh
# /home/xxx.sh
# xxx.sh
if [ x"${JLLPATH}" != x ]; then
    __CvScriptName=${JLLPATH##*/}
    __CvScriptPath=${JLLPATH%/*}
    if [ x"${__CvScriptPath}" = x ]; then
        __CvScriptPath="$(pwd)"
    else
        __CvScriptPath="$(cd ${__CvScriptPath};pwd)"
    fi
    if [ x"${__CvScriptName}" = x ]; then
        echo
        echo "JLL-Exit:: Not recognize the command \"$0\", then exit - 0"
        echo
        exit 0
    fi 
else
    echo
    echo "JLL-Exit:: Not recognize the command \"$0\", then exit - 1"
    echo
    exit 0
fi
JLLPATH="${__CvScriptPath}"
source ${JLLPATH}/BashShellLibrary

# Find the same level path which contains .git folder
Lfn_Sys_GetSameLevelPath  __GitPath ".git"
if [ ! -e "${__GitPath}" ]; then
more >&1<<EOF

JLL-Exit: ${Fred}Not found .git path started from current path${AC}

EOF
    exit 0
fi
clear
echo
echo "JLL-Probe: Found .git path=${Fyellow}${__GitPath}${AC}"
echo

# KeyName Url_with_SSH_rather_than_https 
__JLLCFG_SshKey_RootPath="${HOME}/.sshconf"
declare -a __JLLCFG_SshKey_URLs=(
  "qq1624646454@csdn_github"        "git@github.com:qq1624646454/jllutils.git"
  "qq1624646454@csdn_github"        "git@github.com:qq1624646454/vicc.git"
  "qq1624646454@csdn_github"        "git@github.com:qq1624646454/vicc_installer.git"
  "qq1624646454@csdn_github"        "git@github.com:qq1624646454/JoyfulPuTTY.git"
  "qq1624646454@csdn_github"        "git@github.com:qq1624646454/philipstv_tpv.git"
  "jielong.lin_nopassword@github"   "git@github.com:linjielong/iDSS.git"
)
if [ x"${__JLLCFG_SshKey_URLs}" = x ]; then
more >&1<<EOF

JLL-Exit:: Not found ${Fred}'__JLLCFG_SshKey_URLs[]'${AC}
JLL-Exit:: exit 0

EOF
    unset __JLLCFG_SshKey_RootPath
    exit 0
fi
__JLLCFG_NR_SshKey_URLs=${#__JLLCFG_SshKey_URLs[@]} 
if [ ${__JLLCFG_NR_SshKey_URLs} -lt 1 ]; then
more >&1<<EOF

JLL-Exit:: ${Fred}'__JLLCFG_SshKey_URLs[]'${AC} is invalid because its count is 0.
JLL-Exit::  exit 0

EOF
    unset __JLLCFG_NR_SshKey_URLs
    unset __JLLCFG_SshKey_URLs
    unset __JLLCFG_SshKey_RootPath
    exit 0
fi


__ssh_package=.__ssh_R$(date +%Y_%m_%d__%H_%M_%S)
function __Fn_finalize_GIT()
{
    if [ -e "${HOME}/${__ssh_package}" ]; then
more>&1<<EOF

${Bblue}${Fyellow}JLL-Finalize:: Start restoring sshkey under ${AC}
              ${Fyellow}${HOME}/.ssh${AC} <--- ${Fyellow}${HOME}/${__ssh_package}${AC}

EOF
        if [ -e "${HOME}/.ssh" ]; then
            rm -rvf ${HOME}/.ssh
        fi
        mv -vf ${HOME}/${__ssh_package}  ${HOME}/.ssh
        chmod -R 0500 ${HOME}/.ssh/*
        if [ -e "${HOME}/.ssh/config" ]; then
            chmod +w ${HOME}/.ssh/config*
        fi

more>&1<<EOF

${Bblue}${Fyellow}JLL-Finalize:: End restoring sshkey under ${AC}
              ${Fyellow}${HOME}/.ssh${AC} <--- ${Fyellow}${HOME}/${__ssh_package}${AC}

EOF
    else
more>&1<<EOF

JLL-Finalize:: not found ${Fred}${HOME}/${__ssh_package}${AC}
${Bblue}${Fyellow}JLL-Finalize:: End restoring sshkey and not need to restore sshkey under ${AC}
              ${Fyellow}${HOME}/.ssh${AC} <--- ${Fyellow}${HOME}/${__ssh_package}${AC}

EOF

    fi
}

function __Fn_prepare_GIT()
{
    if [ x"$1" != x"push" -a x"$1" != x"pull" ]; then
more >&1<<EOF

JLL-Prepare:: call prototype failure - ${Fred}__Fn_prepare_GIT "[push|pull]${AC}"
JLL-Exit:: exit 0

EOF
        [ x"${__JLLCFG_SshKey_URLs}" != x ] && unset __JLLCFG_SshKey_URLs
        exit 0
    fi

more>&1<<EOF

${Bblue}${Fyellow}JLL-Prepare:: Start preparing the GIT environment contained the follows:${AC}
                1).provide ~/.ssh or ${HOME}/.ssh for git URL
                2).nothing to do for https URL 

EOF

    if [ x"$1" = x"push" ]; then
        cd ${__GitPath}
        __URL=$(git remote show origin | grep -Ei '^[ \t]{0,}Push[ \t]{1,}URL:')
        cd - >/dev/null
        __URL=${__URL##*URL: }
    fi
    if [ x"$1" = x"pull" ]; then
        cd ${__GitPath}
        __URL=$(git remote show origin | grep -Ei '^[ \t]{0,}Fetch[ \t]{1,}URL:')
        cd - >/dev/null
        __URL=${__URL##*URL: }
    fi

    __is_HTTPS_URL=$(echo "${__URL}" | grep -Ei '^[ \t]{0,}https://')
    if [ x"${__is_HTTPS_URL}" = x ]; then #ssh url should use ssh key
        [ -e "${HOME}/.ssh/id_rsa" ] && __isSSHKey=1 || __isSSHKey=0
        __MyChoice="n"
        if [ ${__isSSHKey} -eq 1 ]; then
            [ x"${__isSSHKey}" != x ] && unset __isSSHKey
more >&1<<EOF

${Bgreen}${Fblack}  GIT Remote Transaction require to using SSH-Key: ${AC}
    ${Fseablue}1) ~/.ssh/id_rsa if press ${Fyellow}[y]${AC};
    ${Fseablue}2) exit if press ${Fyellow}[q]${AC};
    ${Fseablue}3) next to select other SSH-Key if press ${Fyellow}[Other-Any]${AC};
EOF
            read -p "    YourChoice:___ " -n 1 __MyChoice
            echo
            if [ x"${__MyChoice}" = x"q" ]; then
                unset __MyChoice
                [ x"${__JLLCFG_SshKey_URLs}" != x ] && unset __JLLCFG_SshKey_URLs
                [ x"${__JLLCFG_NR_SshKey_URLs}" != x ] && unset __JLLCFG_NR_SshKey_URLs
                [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
                [ x"${__URL}" != x ] && unset __URL
                exit 0
            fi
        fi
        [ x"${__isSSHKey}" != x ] && unset __isSSHKey
        if [ x"${__MyChoice}" != x"y" ]; then
            # Not use the origin SSH Key under ~/.ssh and re-select the new SSH Key for ~/.ssh
            unset __MyChoice
            __isMatch=${__JLLCFG_NR_SshKey_URLs}
            for((__i=0; __i<__JLLCFG_NR_SshKey_URLs; __i+=2)) {
                echo "JLL-Probing:: \"${__JLLCFG_SshKey_URLs[__i+1]}\" = \"${__URL}\""
                if [ x"${__JLLCFG_SshKey_URLs[__i+1]}" = x"${__URL}" ]; then
                    echo "JLL-Hit:: \"${__JLLCFG_SshKey_URLs[__i+1]}\" = \"${__URL}\""
                    __isMatch=${__i}
                    break;
                fi
            }
            [ x"${__URL}" != x ] && unset __URL
            if [ ${__isMatch} -ne ${__JLLCFG_NR_SshKey_URLs} -a \
                -e "${__JLLCFG_SshKey_RootPath}/${__JLLCFG_SshKey_URLs[__isMatch]}" ]; then
                echo "JLL-Using:: ${__JLLCFG_SshKey_RootPath}/${__JLLCFG_SshKey_URLs[__isMatch]}"
                # Replace the ~/.ssh
                if [ -e "${HOME}/.ssh" ]; then
                    echo "JLL-SSHKey:: \"~/.ssh\" is being moved to \"~/${__ssh_package}\""
                    mv -fv ${HOME}/.ssh  ${HOME}/${__ssh_package}
                    echo
                fi
                mkdir -pv ${HOME}/.ssh
                chmod 0777 ${HOME}/.ssh
more >&1<<EOF
JLL-SSHKey:: Setup the appropriate SSH Key as follows:${Fseablue}
               ~/.ssh <-- ${__JLLCFG_SshKey_RootPath}/${__JLLCFG_SshKey_URLs[__isMatch]}${AC}
EOF
                cp -rvf ${__JLLCFG_SshKey_RootPath}/${__JLLCFG_SshKey_URLs[__isMatch]}/*  \
                        ${HOME}/.ssh/
                chmod -R 0500 ${HOME}/.ssh/*
                if [ -e "${HOME}/.ssh/config" ]; then
                    chmod +w ${HOME}/.ssh/config*
                fi
                [ x"${__JLLCFG_SshKey_URLs}" != x ] && unset __JLLCFG_SshKey_URLs
                [ x"${__JLLCFG_NR_SshKey_URLs}" != x ] && unset __JLLCFG_NR_SshKey_URLs
                [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
            else
                if [ -e "${HOME}/.ssh" ]; then
                    echo "JLL-SSHKey: \"~/.ssh\" is being moved to \"~/${__ssh_package}\""
                    mv -fv ${HOME}/.ssh  ${HOME}/${__ssh_package}
                    echo
                fi
                [ x"${__JLLCFG_SshKey_URLs}" != x ] && unset __JLLCFG_SshKey_URLs
                [ x"${__JLLCFG_NR_SshKey_URLs}" != x ] && unset __JLLCFG_NR_SshKey_URLs
                
                ___i=0
                declare -i GvPageUnit=10
                declare -a GvPageMenuUtilsContent
                echo
                echo "JLL-Probing: Collecting all the items from ${__JLLCFG_SshKey_RootPath}"
                __sshconf_list=$(ls -l "${__JLLCFG_SshKey_RootPath}" 2>/dev/null \
                                 | grep -E '^d' | awk -F ' ' '{print $9}')
                for __sshconf_item in ${__sshconf_list}; do
                    echo "JLL-Probing: $___i - ${__sshconf_item}" 
                    GvPageMenuUtilsContent[___i++]="sshkey use: ${__sshconf_item}"
                done
                [ x"${__sshconf_list}" != x ] && unset __sshconf_list
                GvPageMenuUtilsContent[___i]="Install: setup ssh keys then let jllutils over SSH"
                Lfn_PageMenuUtils __result  "Select" 7 4 \
                                  "***** Configure Under \"~/.ssh/\" (q: quit) *****"
                if [ x"${__result}" = x"${GvPageMenuUtilsContent[___i]}" ]; then
                    if [ ! -e "${JLLPATH}/.sshconf/qq1624646454@csdn_github" ]; then
                        [ x"${__result}" != x ] && unset __result
                        [ x"${GvPageUnit}" != x ] && unset GvPageUnit 
                        [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent

more >&1<<EOF
JLL-Exit: Not exist ${Fred}\"${JLLPATH}/.sshconf/qq1624646454@csdn_github\"${AC}
EOF
                        exit 0 
                    fi
                    [ -e "${__JLLCFG_SshKey_RootPath}" ] && rm -rf ${__JLLCFG_SshKey_RootPath}
                    cp -rf ${JLLPATH}/.sshconf ${__JLLCFG_SshKey_RootPath}
                    cp -rf ${JLLPATH}/.sshconf/qq1624646454@csdn_github ${HOME}/.ssh
                    chmod -R 0500 ${HOME}/.ssh/*
                    if [ -e "${HOME}/.ssh/config" ]; then
                        chmod +w ${HOME}/.ssh/config*
                    fi
                    echo
                    echo "JLL-GIT: Change for letting jllutils over SSH"
                    echo

                    if [ ! -e "${JLLPATH}/.git" ]; then
more >&1<<EOF
JLL-Exit: Not change for letting jllutils over SSH - Not exist ${Fred}\"${JLLPATH}/.git\"${AC}
EOF
                        rm -rf ${HOME}/.ssh
                        rm -rf ${__JLLCFG_SshKey_RootPath}
                        mv -fv ${HOME}/${__ssh_package} ${HOME}/.ssh
                        chmod -R 0500 ${HOME}/.ssh/*
                        if [ -e "${HOME}/.ssh/config" ]; then
                            chmod +w ${HOME}/.ssh/config*
                        fi
                        [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
                        [ x"${__result}" != x ] && unset __result
                        [ x"${GvPageUnit}" != x ] && unset GvPageUnit 
                        [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
                        exit 0
                    fi
                    # Change the https URL to git URL for Push
                    # Push  URL: https://github.com/qq1624646454/jllutils.git
                    __RawCTX=$(cd ${JLLPATH} >/dev/null;\
                               git remote show origin \
                               | grep -E "^[ \t]{0,}Push[ \t]{1,}URL:[ \t]{0,}git")
                    if [ x"${__RawCTX}" = x ]; then
                        __RawCTX=$(cd ${JLLPATH} >/dev/null;\
                        git remote show origin | grep -E "^[ ]{0,}Push[ ]{1,}URL: ")
                        __RawCTX=${__RawCTX#*URL:}
                        __RawCTX=${__RawCTX/https:\/\//git@}
                        __RawCTX=${__RawCTX/\//:}
                        if [ x"${__RawCTX}" = x ]; then
more >&1<<EOF
JLL-Exit: Not obtain ${Fred}\"git@URL\"${AC} for the current .git
EOF
                            [ x"${__RawCTX}" != x ] && unset __RawCTX
                            [ x"${__JLLCFG_SshKey_RootPath}" != x ] \
                                && unset __JLLCFG_SshKey_RootPath
                            [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
                            [ x"${__result}" != x ] && unset __result
                            [ x"${GvPageUnit}" != x ] && unset GvPageUnit 
                            [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
                            exit 0
                        fi
                        echo
                        cd ${JLLPATH}
                        git remote set-url --push origin ${__RawCTX}
                        echo
                        git remote show origin
                        cd - >/dev/null
                        [ x"${__RawCTX}" != x ] && unset __RawCTX
                    else
                        cd ${JLLPATH}
                        git remote show origin
                        cd - >/dev/null
                    fi
                    [ x"${__RawCTX}" != x ] && unset __RawCTX
                fi
                if [ x"${__result}" != x"${GvPageMenuUtilsContent[___i]}" ]; then
                    [ x"${GvPageUnit}" != x ] && unset GvPageUnit 
                    [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
                    cp -rvf ${__JLLCFG_SshKey_RootPath}/${__result##*: }/* ${HOME}/.ssh
                    chmod -R 0500 ${HOME}/.ssh/*
                    if [ -e "${HOME}/.ssh/config" ]; then
                        chmod +w ${HOME}/.ssh/config*
                    fi
                fi
                [ x"${GvPageUnit}" != x ] && unset GvPageUnit 
                [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
                [ x"${__result}" != x ] && unset __result
                [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
            fi
more >&1<<EOF

JLL-Prepare:: Backup the origin SSH Key under ~/.ssh and re-select the new SSH Key for ~/.ssh
${Bblue}${Fyellow}JLL-Prepare:: End preparing the GIT environment.${AC}

EOF
        else
            # Hold the origin SSH Key under ~/.ssh and not re-select the new SSH Key for ~/.ssh
            [ x"${__URL}" != x ] && unset __URL
            [ x"${__JLLCFG_SshKey_RootPath}" != x ] && unset __JLLCFG_SshKey_RootPath
            [ x"${__JLLCFG_SshKey_URLs}" != x ] && unset __JLLCFG_SshKey_URLs
            [ x"${__JLLCFG_NR_SshKey_URLs}" != x ] && unset __JLLCFG_NR_SshKey_URLs

more >&1<<EOF

JLL-Prepare:: Hold the origin SSH Key under ~/.ssh and not re-select the new SSH Key for ~/.ssh 
${Bblue}${Fyellow}JLL-Prepare:: End preparing the GIT environment.${AC}

EOF
        fi
    else
        # it is HTTPS without using SSH Key.
more >&1<<EOF

JLL-Prepare:: Checked URL is HTTPS without using SSH Key.
${Bblue}${Fyellow}JLL-Prepare:: End preparing the GIT environment.${AC}

EOF
    fi
    [ x"${__is_HTTPS_URL}" != x ] && unset __is_HTTPS_URL
}


case x"$1" in
x"push")
    cd ${__GitPath}
    __GitCHANGE="$(git status -s)"
    if [ x"${__GitCHANGE}" != x ]; then
        git add -A
        __GitCHANGE="$(git status -s)"
        git commit -m \
"
Commited by using ${__CvScriptName} @ $(date +%Y-%m-%d\ %H:%M:%S)

Changes as follows: 
${__GitCHANGE}
"
 
    fi
more >&1<<EOF

${Bgreen}${Fblack} ******** Selection Menu For GIT Transaction ******* ${AC}
 1) ${Fseablue}quit${AC} if press ${Fyellow}[q]${AC}
 2) run ${Fseablue}git commit --amend${AC} if press ${Fyellow}[y]${AC}
 3) next step to ${Fseablue}git push -f -u origin master${AC} if press ${Fyellow}[Other any]${AC}
EOF
    read -n 1 -p " YourChoice___  " __myChoice
    echo
    if [ x"${__myChoice}" = x"q" ]; then
        cd - >/dev/null
        exit 0
    fi
    if [ x"${__myChoice}" = x"y" ]; then
        git commit --amend
    fi
    cd - >/dev/null 
    __Fn_prepare_GIT push
    cd ${__GitPath}
    git push -f -u origin master
    cd - >/dev/null 
    __Fn_finalize_GIT
    cd ${__GitPath}
    git log \
        --pretty=format:'%Cred%h%Creset  %Cgreen%ce%Creset %Cblue(%cr)%Creset  %C(yellow)%s%Creset' -8
    cd - >/dev/null 
    echo
;;
x"pull")
    cd ${__GitPath}
    if [ x"$(git status -s)" != x ]; then
more >&1<<EOF

JLL-Action:: Remove all changes via ${Fseablue}git clean -dfx; git reset --hard HEAD${AC}
               if press ${Fyellow}[y]${AC}, or ${Fgreen}skip${AC}
EOF
        read -p "              YourChoice:___" -n 1 __MyChoice
        if [ x"${__MyChoice}" = x"y" ]; then
            git clean -dfx;
            git reset --hard HEAD;
        fi
    fi
    cd - >/dev/null 
    __Fn_prepare_GIT pull
    cd ${__GitPath}
    git pull -u origin master
    cd - >/dev/null 
    __Fn_finalize_GIT
    cd ${__GitPath}
    git log \
        --pretty=format:'%Cred%h%Creset  %Cgreen%ce%Creset %Cblue(%cr)%Creset  %C(yellow)%s%Creset' -8
    cd - >/dev/null 
    echo
;;
*)
more >&1 <<EOF

   USAGE:

     ${Fyellow}${__CvScriptName} [help]${AC}

     # If change is checked by 'git status -s', the follows will be run:
     # 'git add -A'
     # 'git commit -m "update by $(basename $0) @Date"'
     # 'git push -u origin master'
     ${Fyellow}${__CvScriptName} push${AC}

     # If change is checked by 'git status -s', the follows will be run: 
     # 'git clean -dfx;git reset --hard HEAD' if approve to cleanup all changes
     # 'git pull -u origin master' is always run
     ${Fyellow}${__CvScriptName} pull${AC}

EOF
;;
esac

exit 0

