//
//  Release.h
//  AirTouch
//
//  Created by Liu, Carl on 8/4/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#ifndef Release_h
#define Release_h

#if defined(Enterprise) && Enterprise
#import "Enterprise.h"
#else
#import "AppStore.h"
#endif

#define isProduct 1

#define BaseRequestUrl                      BaseHTTPRequestURL(ServerTypeProduction)

#define WebSocketConnectUrl                 BaseWebSocketURL(ServerTypeProduction)

#define DeviceControl_Help_Introduction     @"https://acscloud.honeywell.com.cn/hplus/device_intro/index.html?deviceType=%@&userType=%@&country=%@&language=%@&version=4"
#define DeviceControl_Help_DeviceUserManual @"https://acscloud.honeywell.com.cn/hplus/user_manual/home/Usermanual.htm?deviceType=%@&userType=%@&country=%@&language=%@&version=4"

#define FILTER_MEDIA_PAGE                   @"https://acscloud.honeywell.com.cn/hplus/filter/filterpurchase.html"

#define DeviceTypeAndQRCodeUrl              @"https://acscloud.honeywell.com.cn/hplus/model_type/Hplus_DeviceType.txt"

#define CAN_CHANGE_SERVER                   0

#define SHOW_DEBUG_BUTTON                   0

#define LOG_ENABLED                         0

#define COUNTLY_APP_SERVER                  @"https://statistics.homecloud.honeywell.com.cn"
#define COUNTLY_APP_KEY                     @"f792ce760a1f4446d0cd2228129fec88f1acb136"
#define COUNTLY_EVENT_SEND_THRESHOLD        10

#define WEIXIN_APPKEY                       @"wx390720e3d10d4b39"
#define WEIXIN_APPSECRET                    @"68217555d75cbf33774c59e048294045"

#define DefaultListenSharedAccessSignature  @"Endpoint=sb://tccnotification-ns.servicebus.chinacloudapi.cn/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=wiHEzF8JtKUqqaECqE7pk+ZQ8SDjJ3ZKN7+98ZNPQf4="
#define NotificationHubName                 @"tccnotificationpro"

#define UserTerms_EULA                      @"https://acscloud.honeywell.com.cn/hplus/eula/index.html?country=%@&language=%@&version=4"

#define kDefaultAPSkipPhoneName             NO
#endif /* Release_h */
