#!/bin/bash
# This shell script work on BMW Android project, used to replace some environment and test related parameters
# This shell script needs to be execute in the BMW-Android project root directory
# Execute this script like this: ./prebuild-script/BMW-Android.sh Yes(Disable Version Check) Yes(Disable Network Check) Yes(Disable Root Check) Yes(Enable Debug Mode) Yes(Enable Screenshot) Yes(Use Test Plugin SDK)

disable_version_check=$1
disable_network_check=$2
disable_root_check=$3
enable_debug_mode=$4
enable_screenshot=$5
use_test_sdk=$6
android_version=$7
android_versionCode=$8
echo "Current workspace is:"
pwd

echo "Start change Android config parameters"
  echo "change android version";
  echo $android_versionCode;
  if [[ "$android_versionCode" =~ ^[0-9]{8}$ ]]; then
  echo 'android_versionCode success'
  sed -i.bak -- "s/android-versionCode=\"\([0-9]\{8\}\"\)/android-versionCode=\"$android_versionCode\"/g" config.xml
fi
reg='^([0-9]{1,2}).([0-9]{1,2}).([0-9]{1,2})$'

echo $android_version;
  if  [[ "$android_version" =~ $reg ]]; then
  echo 'android_version success'
   sed -i.bak -- "s/version=\"\([0-9]\{1,2\}\).\([0-9]\{1,2\}\).\([0-9]\{1,2\}\"\)/version=\"$android_version\"/g" config.xml
fi
   
if [ "${disable_version_check}" = "Yes" ] ; then
    echo "Disable version and maintenance check";
    sed -i.bak -- "s/<content src=\"wrapperindex.html\" \/\>/<content src=\"wrapperindex.html?restrictedAccess\" \/\>/g" config.xml;
    rm -rf config.xml.bak
fi

if [ "${disable_network_check}" = "Yes" ] ; then
    echo "Disable SSL check"
    sed -i.bak -- "s/.*void onReceivedSslError.*/public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) {handler.proceed();}/g" platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java;
    rm -rf platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java.bak
    echo "Change Android whitelist"
	sed -i.bak -- "/<\!-- Whitelist for Testing -->/a\	
		<access origin=\"*\" \/\>
    	" config.xml
	sed -i.bak -- "/<\!-- Whitelist for Testing -->/a\	
		<allow-navigation href=\"http://*/*\" \/\>
    	" config.xml
	sed -i.bak -- "/<\!-- Whitelist for Testing -->/a\	
		<allow-navigation href=\"https://*/*\" \/\>
    	" config.xml
    rm -rf config.xml.bak  
    echo "Disable SSL pinning";
    sed -i.bak -- "s/.*new SecurityChecker.*/\/\/ new SecurityChecker(this).execute(url, fingerPrint, fingerPrintNew);/g" platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java;
    rm -rf src/com/scb/poc/bmw/BMWWrapperAndroid.java.bak
fi

if [ "${disable_root_check}" = "Yes" ] ; then
    echo "Disable device root check"
    sed -i.bak -- "s/RootUtil.isDeviceRooted(getApplicationContext())/false/g" platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java;
    rm -rf platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java.bak
fi

if [ "${enable_debug_mode}" = "Yes" ] ; then
	echo "Enable debug mode"
	sed -i.bak -- "s/android:debuggable=\"false\">/android:debuggable=\"true\">/g" platforms/android/app/src/main/AndroidManifest.xml
	rm -rf platforms/android/app/src/main/AndroidManifest.xml.bak
fi

if [ "${enable_screenshot}" = "Yes" ] ; then
	echo "Enable screenshot"
	sed -i.bak -- "s/getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);/\/\/ getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);/g" platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java;
    rm -rf platforms/android/app/src/main/java/com/scb/poc/bmw/BMWWrapperAndroid.java.bak
fi

if [ "${use_test_sdk}" = "Yes" ] ; then
	echo "change exocr plugin for test SDK"
	sed -i.bak -- "s/bmw-plugin-exocr/bmw-plugin-exocr-test/g" hooks/after_prepare/custom-plugins-install.sh
	rm -rf hooks/after_prepare/custom-plugins-install.sh.bak
fi
