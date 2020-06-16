//
//  Debug.h
//  AirTouch
//
//  Created by Liu, Carl on 8/4/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#ifndef Debug_h
#define Debug_h

#ifndef DEBUG
#define DEBUG 1
#endif

#warning "This is a debug version"

#define isProduct 0

#define BaseRequestUrl                      BaseHTTPRequestURL(ServerTypeQADevOps)

#define WebSocketConnectUrl                 BaseWebSocketURL(ServerTypeQADevOps)

#define DeviceControl_Help_Introduction     @"https://acscloud.honeywell.com.cn/hplus/qa/device_intro_qa/index.html?deviceType=%@&userType=%@&country=%@&language=%@&version=4"
#define DeviceControl_Help_DeviceUserManual @"https://acscloud.honeywell.com.cn/hplus/qa/user_manual_qa/home/Usermanual.htm?deviceType=%@&userType=%@&country=%@&language=%@&version=4"

#define FILTER_MEDIA_PAGE                   @"https://acscloud.honeywell.com.cn/hplus/qa/filter_qa/filterpurchase.html"

#define VERSION_CHECK_URL                   @"https://homeapp.homecloud.honeywell.com.cn/subphone/whats_new_ios.json"

#define DeviceTypeAndQRCodeUrl              @"https://acscloud.honeywell.com.cn/hplus/qa/model_type_qa/Hplus_DeviceType.txt"

#define CAN_CHANGE_SERVER                   1

#define SHOW_DEBUG_BUTTON                   1

#define LOG_ENABLED                         1

#define COUNTLY_APP_SERVER                  @"https://statistics.homecloud.honeywell.com.cn"
#define COUNTLY_APP_KEY                     @"09f9b5e208bb442608c01325d8d37b66755d2296"
#define COUNTLY_EVENT_SEND_THRESHOLD        10

#define WEIXIN_APPKEY                       @"wx390720e3d10d4b39"
#define WEIXIN_APPSECRET                    @"68217555d75cbf33774c59e048294045"

#define DefaultListenSharedAccessSignature  @"Endpoint=sb://baidunotification-ns.servicebus.chinacloudapi.cn/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=TKao5xPc7HoUZwci7iZTWQpdNt67fRq97drmCL33GpQ="
#define NotificationHubName                 @"baidunh"

#define UserTerms_EULA                      @"https://acscloud.honeywell.com.cn/hplus/qa/eula_qa/index.html?country=%@&language=%@&version=4"

#define kDefaultAPSkipPhoneName             YES

#endif /* Debug_h */
