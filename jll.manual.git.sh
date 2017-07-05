#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary

more >&1 << EOF


# git log help
# //PRETTY FORMAT
# %H: commit hash                %h: abbreviated commit hash
# %an: author name               %ae: author email
# %cn: committer name            %ce: committer email                %cr: committer date, relative
# %d: ref names (各个branch信息) %C(yellow): switch color to yellow     
# %s: subject                    %Cred: switch color to red          %Cgreen: switch color to green
# %Creset: reset color           %Cblue: switch color to blue        %n: newline 
#
# -(n):  only show last n committed records, n is a digit
# --committer=(who) / --author=(who): only show the records associated with committer/author 
# --since,--after: only show the records after the specified date
# --until, --before: only show the records before the specified date
# git log --pretty="%h - %s" --author="jielong.lin\|jll" --since="2016-01-02" --before="2017-05-01"
# git log -2  //only show last 2 records
# git log -2 -p //only show last 2 records and expand the different changes(展开差异变化)
# git log -2 --stat //only show last 2 records and statistic content
# git log --name-only //only show modified files
# git log --name-status //show add,del,modified files
# git log --relative-date //show the relative data to the current, such as 2 weeks ago
#
# --: tell git log about the later parameter is the path format, such as
#       git log -- foo.py bar.py  //show the records associated with foo.py bar.py files.
#
# -S"hello": if you wanna know when the "hello" is added to the code file and committed, -S"hello" can
#            help you to filter and find out the relative records.
#              git log -S"hello" 
#
${Byellow}${Fblue}# customiaze the log format for jielong.lin${AC}
git log --pretty=format:'%Cred%h%Creset  %Cgreen%ce%Creset %Cblue(%cr)%Creset  %C(yellow)%s%Creset' -8

git reflog
git reflog --pretty=format:'%Cred%h%Creset  %Cgreen%ce%Creset %Cblue(%cr)%Creset  %C(yellow)%s%Creset' -8



***************************************************
** How to Use git & repo in Philips TV Project
***************************************************

##
## Switch to another U+ version for Asta M
##
\$${AC}${Fyellow} repo forall -c 'git checkout QM16XE_U_R0.6.0.14'${AC}


##
## Lookup the tag version from the current project
##
\$${AC}${Fyellow} cd frameworks/av ${AC}
\$${AC}${Fyellow} git tag -l QM16* ${AC}
\$${AC}${Fyellow} cd - ${AC}


## 
## The -d/--detach option can be used to switch specified 
## projects back to the manifest revision. This option is
## especially helpful if the project is currently on a topic
## branch, but the manifest revision is temporarily needed.
##
## However, any staged or working directory changes will be retained.
## If you have mucked up your working directory, and need to get it
## back in order  I would do this
##
\$${AC}${Fyellow} repo sync -d ${AC}
\$${AC}${Fyellow} repo forall -c 'git reset --hard HEAD' ${AC}\
# Remove all working directory (and staged) changes.
\$${AC}${Fyellow} repo forall -c 'git clean -dfx' ${AC}# Clean untracked files


## Loop up the commit detail for the only file
## For Example:
##       device/tpvision/common/plf/mediaplayer\$
##       device/tpvision/common/plf/mediaplayer\$ git log -p av/comps/drm/Android.mk 
##
\$${AC}${Fyellow} git log -p filename ${AC}


## Ignore list
##
\$${AC}${Fyellow} vim .gitignore ${Fgreen}
desktop.ini
${Fpink}:w${AC}

##
## Push your changes into master repository"
##
\$${AC}${Fyellow} repo info . ${Fgreen}
Project: ${Fred}platform/vendor/widevine${Fgreen}
Mount path: /home/jielong.lin/aosp_6.0.1_r10_selinux/vendor/widevine
Current revision: ${Fseablue}tpvision/androidm_mprep_selinux${Fgreen}
Local Branches: 0
\$${Fyellow} git push  ssh://gerrit-master/${Fred}platform/vendor/widevine${Fyellow} \\
                HEAD:refs/for/${Fseablue}tpvision/androidm_mprep_selinux${AC}


##
## Lookup the Server from where the data is downloaded
##
\$${AC}${Fyellow} ssh gerrit ${AC}
\$${AC}${Fyellow} ssh gerrit-master ${AC}



##
## Repo sync and then compile error
##
# please switch to another source server inblrgit004.tpvision.com



##
## line feed character in comment by git commit -m 
##
\$${AC}${Fyellow} git commit -m '
  line1
  line2
'${AC}
\$${AC}${Fyellow} git commit --amend${Fgreen} 
  line1
  line2
${AC}



*******************
** Install Git
**
**  git git-doc git-email git-man git-svn gitweb
*******************
${Fyellow} aptitude show git ${AC}
${Fyellow} aptitude install git ${AC}
${Fyellow} aptitude install git-svn ${AC}
${Fyellow} aptitude install git-doc ${AC}
${Fyellow} aptitude install git-email ${AC}
${Fyellow} aptitude install gitweb ${AC}
${Fyellow} aptitude install git-man ${AC}


\$${Bred} ERROR ${AC}
=====================================
Agent admitted failure to sign using 
the key. Permission denied 
(publickey,keyboard-interactive). 
=====================================
\$${Fyellow} cd ~ ${AC}
\$${Fyellow} ssh-add ${AC}






=====================================
git 撤消
=====================================

1. git add 添加 多余文件 
这样的错误是由于， 有的时候 可能 

git add . （空格+ 点） 表示当前目录所有文件，不小心就会提交其他文件

git add 如果添加了错误的文件的话

撤销操作 

git status 先看一下add 中的文件 
git reset HEAD 如果后面什么都不跟的话 就是上一次add 里面的全部撤销了 
git reset HEAD XXX/XXX/XXX.java 就是对某个文件进行撤销了

2. git commit 错误
如果不小心 弄错了 git add后 ， 又 git commit 了。 
先使用 
git log 查看节点 
commit xxxxxxxxxxxxxxxxxxxxxxxxxx 
Merge: 
Author: 
Date: 
然后 
git reset commit_id

over
PS：还没有 push 也就是 repo upload 的时候

git reset commit_id （回退到上一个 提交的节点 代码还是原来你修改的） 
git reset –hard commit_id （回退到上一个commit节点， 代码也发生了改变，变成上一次的）

3.如果要是 提交了以后，可以使用 git revert
还原已经提交的修改 
此次操作之前和之后的commit和history都会保留，并且把这次撤销作为一次最新的提交 
git revert HEAD 撤销前一次 commit 
git revert HEAD^ 撤销前前一次 commit 
git revert commit-id (撤销指定的版本，撤销也会作为一次提交进行保存） 
git revert是提交一个新的版本，将需要revert的版本的内容再反向修改回去，版本会递增，不影响之前提交的内容。





EOF

