FROM gitpod/workspace-full-vnc:latest

USER root

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update                                                  \
    && apt-get install -y default-jdk                               \
             build-essential libdbus-1-dev libgtk-3-dev       \
             libnotify-dev libgconf2-dev       \
             libasound2-dev libcap-dev libcups2-dev libxtst-dev     \
             libxss1 libnss3-dev gcc-multilib g++-multilib curl     \
             gperf bison                            \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*




USER gitpod

RUN mkdir -p /home/gitpod/rocksetta                                                                            \
    && mkdir -p /home/gitpod/rocksetta/logs                                                                    \
    && mkdir -p /home/gitpod/.android/cmdline-tools                                                                          \
    && touch /home/gitpod/.android/repositories.cfg                                                            \
    && touch /home/gitpod/rocksetta/logs/mylogs.txt                                                            \
    && echo "Installation start, made some folders in /home/gitpod" >> /home/gitpod/rocksetta/logs/mylogs.txt  \
    && echo "Try installing cordova, ionic, qrcode, @ionic/lab, cordova-res, native-run  @capacitor/core @capacitor/cli electron electron-packager " >> /home/gitpod/rocksetta/logs/mylogs.txt  \
    && npm install -g cordova ionic qrcode @ionic/lab cordova-res native-run @capacitor/core @capacitor/cli electron  electron-packager                               \
    && echo "Back to root to install the Android sdk" >> /home/gitpod/rocksetta/logs/mylogs.txt








# Give back control
USER root



 ENV ANDROID_SDK_ROOT /home/gitpod/.android
 ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin

WORKDIR /home/gitpod/.android/cmdline-tools

# https://stackoverflow.com/questions/46402772/failed-to-install-android-sdk-java-lang-noclassdeffounderror-javax-xml-bind-a#answer-58652345
RUN wget -O sdk-tools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip     \
    && unzip sdk-tools-linux.zip                                          \
    && rm sdk-tools-linux.zip                                             \
    && chmod -R 775 /home/gitpod/.android                                         \
    && chown -R gitpod:gitpod /home/gitpod/.android


USER gitpod


RUN  echo "Here is the android sdk" >> /home/gitpod/rocksetta/logs/mylogs.txt             \
     && ls -ls /home/gitpod/.android >> /home/gitpod/rocksetta/logs/mylogs.txt            \
     &&  echo "Installation all done" >> /home/gitpod/rocksetta/logs/mylogs.txt

#RUN sysctl kernel.unprivileged_userns_clone=1

# Give back control
USER root


# Cleaning
RUN apt-get clean
