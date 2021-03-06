#!/bin/bash  

# Probably not a good idea to make this online. 
# shows some of the steps to make an Android release version
# This is very old the step probably have changed

mkdir /home/gitpod/keystore
cd /home/gitpod/keystore

echo "You will be asked for two passwords to enter. A keystore password and a key (alias) password for this app". 
echo "Both passwords can be the same"
echo "This will become the name of the keystore file, and will also be the alias name"
echo "You can have one keystore file for lots of Apps, but we are doing it simply"
echo ""
echo "Enter the main directory name for your App. Example helloAnt"
read myStoreName

#keytool -genkey -v -keystore $myStoreName.keystore -alias $myStoreName -keyalg RSA -validity 999999
#keytool -genkey -v -keystore <App-Name>.keystore -alias <Alias Name> -keyalg RSA -keysize 2048 -validity 10000




echo "checking if keystore for this folder has been made"

if [ -d /home/keystore/$myStoreName.keystore ]
  then
     echo "Making new keystore for $myStoreName"
     keytool -genkey -v -keystore $myStoreName.keystore -alias $myStoreName -keyalg RSA -keysize 2048 -validity 10000
  else
     echo "keystore for $myStoreName has already been made"
fi







#echo ""
#echo "Now we need to update your ant. properties file, which normally has nothing in it. It needs"
#echo "key.store=/home/keystore/$myStoreName.keystore"
#echo "key.alias=$myStoreName"

cd /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName


# you have to make the build.gradle changes
#printf "\n\nkey.store=/home/keystore/$myStoreName.keystore\nkey.alias=$myStoreName"  >> /home/ubuntu/workspace/my-gitpod-capacitor/$myStoreName/ant.properties
echo "----------------------------------------------"
echo "Making Gradle unaligned unsigned release .apk"
echo "----------------------------------------------"

./android/gradlew assembleRelease

echo "----------------------------------------------"
echo "back to the keystore folder"
echo "Signing the unaligned .apk"
echo "----------------------------------------------"

# helloGradle-release-unsigned.apk
#cd /home/keystore

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore  /home/gitpod/keystore/$myStoreName.keystore /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk/$myStoreName-release-unsigned.apk $myStoreName





jarsigner -verify -verbose -certs /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk/$myStoreName-release-unsigned.apk

echo "----------------------------------------------"
echo "Aligning and naming the final signed aligned .apk"
echo "----------------------------------------------"




build-tools/29.0.1/zipalign -v 4 /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk/$myStoreName-release-unsigned.apk /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk/$myStoreName.apk
#sudo /home/ubuntu/workspace/android-sdk-linux/build-tools/23.0.2/zipalign -v 4 /home/ubuntu/workspace/helloGradle/build/outputs/apk/helloGradle-release-unsigned.apk /home/ubuntu/workspace/helloGradle/build/outputs/apk/helloGradle.apk


# to view keystore information
# keytool -list -v -keystore $myStoreName.keystore





#android {
#    compileSdkVersion 'android-20'
#    buildToolsVersion '23.0.2'
#    signingConfigs {
#        release {
#            storeFile file("/home/keystore/helloGradle.keystore")
#            keyAlias "helloGradle"
#        }
#    }
#    
#    buildTypes {
#        release {
#            runProguard false
#            proguardFile getDefaultProguardFile('proguard-android.txt')
#        }
#    }
#}









cd /home/gitpod/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk

#cp /home/ubuntu/start-here/a10-generate-gradle-release.sh /home/ubuntu/workspace/my-gitpod-capacitor/$myStoreName/a10-generate-gradle-release.sh


ls





INDEXFILE="/home/ubuntu/workspace/index.html"

printf "\n\n$myStoreName-release.apk, $(date), <a href='../$myStoreName/build/outputs/apk/$myStoreName-release.apk'>../$myStoreName/build/outputs/apk/$myStoreName-release.apk</a><br>"  >> $INDEXFILE




echo "Look for you new android /home/ubuntu/workspace/my-gitpod-capacitor/$myStoreName/build/outputs/apk/$myStoreName-release.apk"
echo "right-click run index.html, then preview-preview running application to view webpage with .apk"
echo ""
echo ""
echo "Click this link to open your index.html web page"
echo ""
echo ""

echo "http://$C9_HOSTNAME"
