#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin.  All rights reserved.
#
#   FileName:     jll.manual.AndroidStudio.sh
#   Author:       jielong.lin
#   Email:        493164984@qq.com
#   DateTime:     2017-05-23 14:08:54
#   ModifiedTime: 2017-07-18 09:27:35

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary

more >&1<<EOF



${Bred}${Black}                                     ${AC}
${Bred}  ${AC} ${Fred}Looking in classpath from com.intellij.util.lang.UrlClassLoader@6d5380c2${AC}
${Bred}  ${AC} ${Fred}for libnotify.so.4${AC} After Install Android Studio 2.3.3 in Ubuntu 12.04 
${Bred}  ${AC} 64bit. 
${Bred}${Black}                                     ${AC}
sudo apt-get install libnotify-dev


${Bred}${Black}                                     ${AC}
${Bred}  ${AC} ${Fred}A solution for pulseaudio: pa_context_connect() failed with QEMU ${AC}
${Bred}${Black}                                     ${AC}
sudo aptitude install pulseaudio




${Bred}${Black}                                     ${AC}
${Bred}  ${AC} 定制任意路径下的Android模拟器运行环境 
${Bred}${Black}                                     ${AC}
${Fyellow}将以下脚本写入~/.bashrc，并重新登录即可${AC}
alias as_emulator="ls ~/.android/avd | awk -F'.ini' '{print \$1}' | awk -F'.avd' '{print \$1}' \
| uniq;
read -p \"please type AVD=\" AVD_name;
[ x\"\${AVD_name}\" != x ] \
&& ~/dl.google.com/android/repository/emulator/emulator -avd \"\${AVD_name}\" -gpu swiftshader \
"



${Bred}${Black}                                     ${AC}
${Bred}  ${AC} Install Android Studio 2.3.3 in Ubuntu 12.04 64bit. 
${Bred}${Black}                                     ${AC}
wget https://dl.google.com/dl/android/studio/ide-zips/2.3.3.0/android-studio-ide-162.4069837-linux.zip
unzip android-studio-ide-162.4069837-linux.zip -d ./
cd android-studio/
vim Install-Linux-tar.txt
./bin/studio.sh
${Fyellow}第一次运行需要进行很多配置,包含下载和安装SDK等等，建议保证网络通畅，时间上会比较久.${AC}

${Fyellow}为了让AndroidStudio可以在任何路径下运行，建议将studio.sh所在路径写入到环境变量PATH中.${AC}

${Fyellow}下次运行studio.sh即可以启动AndroidStudio${AC}

${Fyellow}第一次编译工程时，AS可能还需要去下载gradle包进行安装${AC}





${Bred}${Black}                                     ${AC}
${Bred}  ${AC} AVD(Android Virtual Device) in Ubuntu 12.04 64bit. 
${Bred}  ${AC} /dev/kvm 未授权给普通用户访问
${Bred}${Black}                                     ${AC}
sudo chmod 0777 /dev/kvm
${Fyellow}每次开机后，都需要作一次这样的操作，所以建议将其定制到/etc/rc.local${AC}
sudo vim /etc/rc.local
/bin/chmod 0777 /dev/kvm




${Bred}${Black}                                     ${AC}
${Bred}  ${AC} AVD(Android Virtual Device) in Ubuntu 12.04 64bit. 
${Bred}  ${AC} 模拟器界面弹出后，又立刻闪退 
${Bred}${Black}                                     ${AC}
${Fyellow}ANALYZE: 使用命令行单独测试AVD，可以看到详细的错误信息${AC}
${Fyellow}通过AndroidStudio--->AVD Manager-->Actions(Edit this AVD)获取AVD的信息${AC}
Name: Android_TV_720p_API_23
CPU/ABI: Android TV Intel Atom (x86)
...
hw.accelerometer: no
...
hw.gpu.mode: auto
...
${Fyellow}hw.gpu.enabled: yes${AC}
...

${Fseablue}在Android SDK目录下， tools/emulator是专门用于运行Android的模拟器(qemu)${AC}
jielong.lin@TpvServer:~/Android/Sdk/tools$ \
${Fseablue}~/Android/Sdk/tools/emulator -avd Android_TV_720p_API_23${AC}
${Fred}sh: 1: glxinfo: not found${AC}
emulator: WARNING: encryption is off
android/android-emugl/host/libs/Translator/GLES_V2/GLESv2Imp.cpp:glShaderSource:2452 error 0x501
...
android/android-emugl/host/libs/Translator/GLES_V2/GLESv2Imp.cpp:glGetProgramiv:1747 error 0x501
X Error of failed request:  GLXBadContextTag
  Major opcode of failed request:  150 (GLX)
  Minor opcode of failed request:  1 (X_GLXRender)
  Serial number of failed request:  244
  Current serial number in output stream:  246
QObject::~QObject: Timers cannot be stopped from another thread
Segmentation fault (core dumped)
jielong.lin@TpvServer:~/Android/Sdk/tools$
jielong.lin@TpvServer:~/Android/Sdk/tools$ ${Fseablue}sudo apt-get install glxinfo ${AC}
...





${Bred}${Black}                                     ${AC}
${Bred}  ${AC} Could not reserve enough space for object heap
${Bred}${Black}                                     ${AC}


${Bgreen}${Fwhite}Here is how to fix it:${AC}

Go to Start->Control Panel->System->Advanced(tab)->Environment Variables->System
Variables->New: Variable name: _JAVA_OPTIONS
Variable value: -Xmx512M
Variable name: Path
Variable value: %PATH%;C:\Program Files\Java\jre6\bin;F:\JDK\bin;
Change this to your appropriate path.






${Bred}${Black}                                     ${AC}
${Bred}  ${AC} How to kill the tadb.exe in Windows. 
${Bred}${Black}                                     ${AC}
在windows命令行窗口下执行： 
1.查看所有的端口占用情况
${Fyellow}C:\\>netstat -ano${AC}
  协议    本地地址        外部地址    状态         PID
  TCP    127.0.0.1:${Fyellow}8700${AC}   0.0.0.0:0   LISTENING    3236

2.查看指定端口的占用情况
${Fyellow}C:\\>netstat -aon|findstr "8700" ${AC}
  协议    本地地址        外部地址    状态         PID
  TCP    127.0.0.1:8700   0.0.0.0:0   LISTENING    ${Fyellow}2014${AC}

3.查看PID对应的进程
${Fyellow}C:\\>tasklist|findstr "2014" ${AC}
 映像名称                  PID      会话名           会话#  内存使用
 ========================= ======== ================
 tadb.exe                  2014     Console          0      16,064 K

4.结束该进程
${Fyellow}C:\\>taskkill /f /t /im tadb.exe ${AC}


EOF

