#!/bin/bash
# This shell script work on CN iOS project, used to replace some environment and test related parameters
# This shell script needs to be excuated in the BMW-iOS project root directory
# Excuated this script like this: ./prebuild-script/BMW-iOS.sh CASA-SIT(BSOI Environment) Yes(Disable Version Check) Yes(Disable Network Check) Yes(Disable Jailbreak Check)

bsoi_environment=$1
disable_version_check=$2
disable_network_check=$3
disable_jailbreak_check=$4

echo "Current workspace is:"
pwd

echo "Start to change iOS BSOI environment"

sed -i.bak -- "/\<key\>ENVIRONMENT\<\/key\>/{n;s/\<string\>.*\<\/string\>/\<string\>${bsoi_environment}\<\/string\>/g;}" iphone/BreezeCN-Production-Info.plist
rm -rf iphone/BreezeCN-Production-Info.plist.bak

sed -i.bak -- "/\<key\>ENVIRONMENT\<\/key\>/{n;s/\<string\>.*\<\/string\>/\<string\>${bsoi_environment}\<\/string\>/g;}" iphone/BreezeCN-Testing-Info.plist
rm -rf iphone/BreezeCN-Testing-Info.plist.bak

# Need to change the log level for production environment
if [ "${bsoi_environment}" = "PRODUCTION" ] ; then
    echo "Change the log level for producion environment"
    sed -i.bak -- "/\<key\>UI_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Production-Info.plist
    sed -i.bak -- "/\<key\>WS_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Production-Info.plist
    sed -i.bak -- "/\<key\>NC_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Production-Info.plist
    sed -i.bak -- "/\<key\>BL_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Production-Info.plist
    rm -rf iphone/BreezeCN-Production-Info.plist.bak
    sed -i.bak -- "/\<key\>UI_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Testing-Info.plist
    sed -i.bak -- "/\<key\>WS_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Testing-Info.plist
    sed -i.bak -- "/\<key\>NC_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Testing-Info.plist
    sed -i.bak -- "/\<key\>BL_LOG_LEVEL\<\/key\>/{n;s/\<integer\>.*/\<integer\>0\<\/integer\>/;}" iphone/BreezeCN-Testing-Info.plist
    rm -rf iphone/BreezeCN-Testing-Info.plist.bak
fi

echo "Start change iOS config"

# Remove remote version check and maintenance check
if [ "${disable_version_check}" = "Yes" ] ; then
    echo "Disable version and maintenance check"
    # sed -i.bak -- "s/\[\[self getAsString:@\"offline\"\] isEqualToString:@\"true\"\]/false/g" iphone/Classes/ui/touchid/LoadingView.m
    # rm -rf iphone/Classes/ui/touchid/LoadingView.m.bak
    sed -i.bak -- "s/!remoteSettings\.isRunningAllowedVersion/YES/g" iphone/Classes/business/model/RemoteSettings.m
    rm -rf iphone/Classes/business/model/RemoteSettings.m.bak
    sed -i.bak -- "s/.*MASTER_SWITCH_ENABLED.*/if(NO){/" iphone/Classes/business/api/API+RemoteSettings.m
    sed -i.bak -- "s/.*NOTIFICATIONS_ENABLED.*/if(NO){/" iphone/Classes/business/api/API+RemoteSettings.m
    rm -rf iphone/Classes/business/api/API+RemoteSettings.m.bak
    sed -i.bak -- "s/.*FESTIVE_BACKGROUND_ENABLED.*/if(NO){/" iphone/Classes/BreezeAppDelegate.m
    rm -rf iphone/Classes/BreezeAppDelegate.m.bak
fi

# Change the url whitelist config
if [ "${disable_network_check}" = "Yes" ] ; then
    echo "Disable SSL check"
    sed -i.bak -- "s/\/\/#define PRODUCTION/#define PRODUCTION/g" iphone/Breeze_Prefix.pch
    rm -rf iphone/Breeze_Prefix.pch.bak
    sed -i.bak -- "s/.*allowsAnyHTTPSCertificateForHost.*/+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host{return YES;}/g" iphone/Classes/ssl/NSURLRequest+NSURLRequestWithIgnoreSSL.m
    rm -rf iphone/Classes/ssl/NSURLRequest+NSURLRequestWithIgnoreSSL.m.bak
    sed -i.bak -- "s/\[self._delegate dangerNetwork\];/\/\/\[self._delegate dangerNetwork\];/" iphone/Classes/SecurityChecker.m
    rm -rf iphone/Classes/SecurityChecker.m.bak
    echo "Change whitelist for iOS device"
    sed -i.bak -- "s/<access origin=.*/<access origin=\"*\" \/\>/g" iphone/Cordova/config.xml
    rm -rf iphone/Cordova/config.xml.bak
fi

# Change the jailbreak config
if [ "${disable_jailbreak_check}" = "Yes" ] ; then
    echo "Disable device jailbreak check"
    sed -i.bak -- "s/.*WrapperUtils jailBroken.*/if(NO)/" iphone/Classes/BreezeAppDelegate.m
    rm -rf iphone/Classes/BreezeAppDelegate.m.bak
fi
