#!/bin/bash
# Copyright(c) 2016-2100.  Jielong Lin.  All rights reserved.
#
#   FileName:     riv_ota_pkg_maker_M120A_M160NP.sh 
#   Author:       Jielong Lin 
#   Email:        493164984@qq.com
#   DateTime:     2020-01-14 12:19:23
#   ModifiedTime: 2020-01-14 15:35:00

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"


#unzip M160Y-ota-eng.root.zip -d M160Y-ota-eng.root

_ota_path=M160Y-ota-eng.root


if [ x"$1" = x ]; then
    echo
    echo "ERROR: Parameter should not be null"
    echo "Please specify version as follows:"
    echo "    20180908.180717"
    echo
    exit 0
fi

if [ x"$(echo $1 | grep -e '^[0-9]\{1,\}\.[0-9]\{1,\}$')" = x ]; then
    echo
    echo "ERROR: Parameter format invalid"
    echo "Please specify version as follows:"
    echo "    20180908.180717"
    echo
    exit 0
fi




#Backup all origin ota package
if [ ! -e "$(pwd)/${_ota_path}__origin.zip" ]; then
    zip -r9 ${_ota_path}__origin.zip ${_ota_path}
fi

if [ ! -e "$(pwd)/${_ota_path}__origin.zip" ]; then
    echo
    echo "ERROR: Not found ${_ota_path}__origin.zip"
    echo
    exit 0
fi

if [ -e "$(pwd)/${_ota_path}" ]; then
    rm -rf $(pwd)/${_ota_path}
    echo
    echo "Remove old ota pkg then re-extrace from ${_ota_path}__origin.zip"
fi
unzip ${_ota_path}__origin.zip -d ./

if [ ! -e "$(pwd)/${_ota_path}/META-INF/com/google/android/updater-script" -o \
     ! -e "$(pwd)/${_ota_path}/META-INF/com/google/android/update-binary"  \
]; then
    echo
    echo "ERROR: Please enter legal path included M160Y-ota-eng.root"
cat >&1<<EOF

  For Example:
    . #here is the legal path in which riv_ota_maker_M120A_M160NP.sh can generate update.zip
    │ 
    └── ${_ota_path} 
        ├── boot.img
        ├── META-INF
        │   ├── CERT.RSA
        │   ├── CERT.SF
        │   ├── com
        │   │   ├── android
        │   │   │   ├── metadata
        │   │   │   └── otacert
        │   │   └── google
        │   │       └── android
        │   │           ├── update-binary
        │   │           └── updater-script
        │   └── MANIFEST.MF
        └── system
            ├── build.prop
            └── build.prop.bakforspec

EOF
    echo
    exit 0
fi


declare -a _lstBuildProp=(
    ${_ota_path}/system/build.prop
    ${_ota_path}/system/build.prop.bakforspec
)

_nrLstBuildProp=${#_lstBuildProp[@]}
for((i=0; i<_nrLstBuildProp; i++)) {
    if [ ! -e "$(pwd)/${_lstBuildProp[i]}" ]; then
        echo "Not found ${_lstBuildProp[i]} @$(pwd)"
        unset _lstBuildProp
        unset _nrLstBuildProp
        exit 0
    fi
}


#Modify build version 
for((i=0; i<_nrLstBuildProp; i++)) {
    sed "s/eng\.root\.[0-9]\{1,\}\.[0-9]\{1,\}/eng.root.$1/g" -i $(pwd)/${_lstBuildProp[i]}
}

#Packing all related files with unsigned
cd M160Y-ota-eng.root
zip -qry ../update_unsigned.zip *
cd .. >/dev/null

#Signing zip packing file
java -jar ../../../out/M160Y/host/linux-x86/framework/signapk.jar \
       -w ../../../build/target/product/security/releasekey.x509.pem \
          ../../../build/target/product/security/releasekey.pk8 \
          update_unsigned.zip \
          update.zip
mkdir -pv eng.root.$1
mv -f update.zip eng.root.$1

cat >eng.root.$1/readme<<EOF
*********************************************************************
    README
                    $(date +%Y-%m-%d\ %H:%M:%S) Release
                    Automatically Generated by Reach Tech Tool
                    Author: linjielong@reachxm.com
                    Platform: M120A/M160NP  Android4.x+
*********************************************************************


-----------------------------------
 How to ota for system upgrade
-----------------------------------
1.Retrieving update.zip by extracting eng.root.$1.zip 
  unzip eng.root.$1.zip -d ./
2.Push update.zip to /cache in target system by adb tool
  adb push eng.root.$1/update.zip /cache/ 
3.Write command file to tell recovery system for ota upgrade
  adb shell 'echo "--update_package=/cache/update.zip" >/cache/command'
4.Reboot system into recovery for ota upgrade
  adb reboot recovery



-----------------------------------
 Change Information Release 
-----------------------------------
EOF
if [ x"$2" = x ]; then
    vim eng.root.$1/readme
else
    echo -e "$2" >>eng.root.$1/readme
fi

zip -r9 eng.root.$1.zip eng.root.$1

echo
echo
read -n 1 -p 'Push \"update.zip\" to /cache if press [y]: ' isY
echo
if [ x"${isY}" = x"y" ]; then
    adb push eng.root.$1/update.zip /cache/ 
    sleep 1
    echo "    echo \"--update_package=/cache/update.zip\" >/cache/command"
    adb shell 'echo "--update_package=/cache/update.zip" >/cache/command'
fi

read -n 1 -p 'Let system reboot to Recovery if press [y]: ' isY
if [ x"${isY}" = x"y" ]; then
    adb reboot recovery
fi

[ -e "$(pwd)/update_unsigned.zip" ] && rm -rf $(pwd)/update_unsigned.zip


unset _lstBuildProp
unset _nrLstBuildProp


