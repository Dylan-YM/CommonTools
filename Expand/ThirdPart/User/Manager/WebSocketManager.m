//
//  WebSocketManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 04/07/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import "NSURLRequest+SRWebSocket.h"
#import "LogUtil.h"
#import "TimerUtil.h"
#import "AppMarco.h"

#import "AppConfig.h"
#import "HWUpdateLanguageManager.h"
#import "UserEntity.h"
#import "DateTimeUtil.h"
#import "NetworkUtil.h"

#define kTimerNameUpdateLanguage @"kTimerNameUpdateLanguage"

extern NSString * HWPercentEscapedStringFromString(NSString *string);

static NSString * const PROD_WEB_CERT = @"PROD_WEB_CERT";

@interface WebSocketManager () <SRWebSocketDelegate>

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (assign, nonatomic) WebSocketState state;
@property (strong, nonatomic) NSMutableAttributedString *webSocketResultString;
@property (assign, nonatomic) NSUInteger wsIndex;
@property (strong, nonatomic) NSArray *certArray;
@property (assign, nonatomic) NSInteger certIndex;

@property (strong, nonatomic) HWUpdateLanguageManager *updateLanguageManager;

@end

@implementation WebSocketManager

+ (WebSocketManager *)instance {
    static WebSocketManager *ws = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ws = [[WebSocketManager alloc] init];
    });
    return ws;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTokenChanged) name:kNotification_LoginTokenChanged object:nil];
        
        self.certArray = @[@"qa",@"prod",@"prod_new"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger certIndex = [defaults integerForKey:PROD_WEB_CERT];
        if (certIndex >= 0 && certIndex < self.certArray.count) {
            self.certIndex = certIndex;
        }
        
        __weak typeof(self) weakSelf = self;
        [TimerUtil scheduledDispatchTimerWithName:@"Timer" timeInterval:300 repeats:YES action:^{
            if (weakSelf.state == WebSocketStateConnected) {
                [weakSelf.webSocket sendPing:[@"{}" dataUsingEncoding:NSUTF8StringEncoding] error:NULL];
            }
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationEnterForeground {
    if ([[UserEntity instance] status] == UserStatusLogin) {
        [self connect];
    }
}

- (void)applicationEnterBackground {
    if (self.state == WebSocketStateConnected) {
        [self disconnect];
    }
}

- (void)loginTokenChanged {
    if ([[UserEntity instance] status] == UserStatusLogin) {
        [self disconnect];
        [self connect];
    }
}

- (void)connect {
    if ([UserEntity instance].status != UserStatusLogin) {
        self.state = WebSocketStateInvalid;
        return;
    }
    [LogUtil Debug:@"Websocket" message:@"Websocket connecting..."];
    
    NSMutableDictionary *jsonParam = [NSMutableDictionary dictionary];
    jsonParam[@"autoLoginToken"] = [UserEntity instance].loginToken?:@"";
    jsonParam[@"phoneUUID"] = [AppConfig like_uuid];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonParam options:0 error:NULL];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encoded = HWPercentEscapedStringFromString(jsonStr);
    
    NSMutableString *urlString = [NSMutableString string];
    NSString *webSocketUrl = WebSocketConnectUrl;
    if (CAN_CHANGE_SERVER) {
        if ([AppConfig getValueString:WebSocketLocaiton]) {
            webSocketUrl = [AppConfig getValueString:WebSocketLocaiton];
        }
    }
    
    NSString *currentWSURL = @"";
    NSArray *wsUrl = [UserEntity instance].wsUrl;
    if ([wsUrl count] > 0) {
        if (self.wsIndex < [wsUrl count]) {
            currentWSURL = wsUrl[self.wsIndex];
        } else {
            self.wsIndex = 0;
            currentWSURL = wsUrl[0];
        }
    } else {
        currentWSURL = @"/v1/websocket";
    }
    webSocketUrl = [webSocketUrl stringByAppendingString:currentWSURL];
    [urlString appendString:webSocketUrl];
    [urlString appendString:@"?t="];
    [urlString appendString:encoded];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    if ([webSocketUrl hasPrefix:@"wss:"]) {
        NSString *cerName = nil;
        if ([webSocketUrl containsString:BaseWebSocketURL(ServerTypeProduction)] ||
            [webSocketUrl containsString:BaseWebSocketURL(ServerTypeStage)]) {
            cerName = self.certArray[self.certIndex];
        } else {
            cerName = @"prod_new";
        }
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"];
        NSData *certData = [[NSData alloc] initWithContentsOfFile:cerPath];
        CFDataRef certDataRef = (__bridge CFDataRef)certData;
        SecCertificateRef certRef = SecCertificateCreateWithData(NULL, certDataRef);
        id certificate = (__bridge id)certRef;
        if (certificate) {
            [request setSR_SSLPinnedCertificates:@[certificate]];
        }
    }
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    
    [_webSocket open];
    self.state = WebSocketStateConnecting;
}

- (void)disconnect
{
    [LogUtil Debug:@"Websocket" message:@"Websocket disconnecting..."];
    _webSocket.delegate = nil;
    [_webSocket close];
    self.state = WebSocketStateInvalid;
}

- (void)reconnect
{
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground) {
        return;
    }
    [self disconnect];
    self.state = WebSocketStateReconnecting;
    
    [self refreshSessionWithUpdageLanguage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.state == WebSocketStateReconnecting) {
            NSArray *wsUrl = [UserEntity instance].wsUrl;
            if (wsUrl.count > 0) {
                self.wsIndex++;
                self.wsIndex = self.wsIndex%wsUrl.count;
            }
            [self connect];
        }
    });
}

- (void)swtichProdutionCert {
    self.certIndex++;
    self.certIndex = self.certIndex%self.certArray.count;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.certIndex forKey:PROD_WEB_CERT];
    [defaults synchronize];
}

- (void)setState:(WebSocketState)state {
    _state = state;
    [self append:[self stateTitle] type:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketStateDidChangeNotification object:self];
}

- (void)refreshSessionWithUpdageLanguage {
    if ([TimerUtil isValid:kTimerNameUpdateLanguage]) {
        return;
    }
    [self updateLanguageManager];
    [TimerUtil scheduledDispatchTimerWithName:kTimerNameUpdateLanguage timeInterval:60 repeats:YES action:^{
        [self updateLanguageManager];
    }];
}

- (void)updateLanguage {
    HWUpdateLanguageManager *manager = [[HWUpdateLanguageManager alloc] init];
    NSString *osLanguage = [AppConfig getLanguage];
    if ([osLanguage isEqualToString:@"en"]) {
        osLanguage = @"en_us";
    } else if ([osLanguage isEqualToString:@"zh"]) {
        osLanguage = @"zh_cn";
    }
    NSDictionary *param = @{@"osLanguage":osLanguage};
    [manager callAPIWithParam:param completion:^(id object, NSError *error) {
    }];
}

- (void)append:(NSObject *)object type:(NSInteger)type {
#if defined(DEBUG) && DEBUG
    NSDictionary *normalAttribute = @{NSForegroundColorAttributeName : Hplus_Color_Font_Black,
                                      NSFontAttributeName : [UIFont systemFontOfSize:14]};
    NSDictionary *highlightAttribute = @{NSForegroundColorAttributeName : Hplus_Color_Blue,
                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    NSDictionary *errorAttribute = @{NSForegroundColorAttributeName : Hplus_Color_Red,
                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    NSDictionary *successAttribute = @{NSForegroundColorAttributeName : Hplus_Color_Success,
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    
    if (self.webSocketResultString == nil) {
        self.webSocketResultString = [[NSMutableAttributedString alloc] init];
        [self.webSocketResultString appendAttributedString:[[NSAttributedString alloc] initWithString:@"WebSocket Log" attributes:highlightAttribute]];
    }
    NSString *date = [[[DateTimeUtil instance] getNowDateTimeString] substringFromIndex:11];
    [self.webSocketResultString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@ ", date] attributes:normalAttribute]];
    
    NSString *title = @"";
    NSString *value = @"";
    NSDictionary *valueAttribute = normalAttribute;
    if ([object isKindOfClass:[NSString class]]) {
        value = (NSString *)object;
    } else if ([object isKindOfClass:[NSData class]]) {
        value = [[NSString alloc] initWithData:(NSData *)object encoding:NSUTF8StringEncoding];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:(NSDictionary *)object options:NSJSONWritingPrettyPrinted error:NULL];
        value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    if (type == 1) {
        title = @"Request : \n";
    } else if (type == 2) {
        title = @"Response : \n";
    } else if (type == 3) {
        title = @"State Change : ";
        switch ([WebSocketManager instance].state) {
            case WebSocketStateInvalid:
            case WebSocketStateConnecting:
            case WebSocketStateReconnecting:
                valueAttribute = errorAttribute;
                break;
            case WebSocketStateConnected:
                valueAttribute = successAttribute;
                break;
            default:
                break;
        }
    }
    [self.webSocketResultString appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:highlightAttribute]];
    [self.webSocketResultString appendAttributedString:[[NSAttributedString alloc] initWithString:value attributes:valueAttribute]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketMessageUpdateNotification object:self userInfo:nil];
#endif
}

- (NSString *)stateTitle {
    NSString *title = @"";
    switch ([WebSocketManager instance].state) {
        case WebSocketStateInvalid:
            title = @"Invalid";
            break;
        case WebSocketStateConnected:
            title = @"Connected";
            break;
        case WebSocketStateConnecting:
            title = @"Connecting";
            break;
        case WebSocketStateReconnecting:
            title = @"Reconnecting";
            break;
        default:
            break;
    }
    return title;
}

- (void)clearLog {
    self.webSocketResultString = nil;
}

#pragma mark - Handle Data
- (NSString *_Nullable)sendWithType:(NSString *_Nonnull)messageType data:(NSObject *_Nonnull)messageData flag:(WebSocketMessageFlag)messageFlag messageId:(NSString *_Nullable )messageId {
    if (self.state != WebSocketStateConnected) {
        [self analyzeMessage:@{
                               kWebSocketMsgType:messageType,
                               kWebSocketErrorCode:@(HWErrorInternalServerError)
                               }];
        return nil;
    }
    NSString *flag = @"";
    switch (messageFlag) {
        case WebSocketMessageFlagRequest:
            flag = kWebSocketMsgFlagRequest;
            break;
        case WebSocketMessageFlagResponse:
            flag = kWebSocketMsgFlagResponse;
            break;
        default:
            break;
    }
    if (messageId == nil) {
        messageId = [AppConfig uuidString];
    }
    NSDictionary *object = @{kWebSocketMsgData:messageData,
                              kWebSocketMsgFlag:flag,
                              kWebSocketMsgId:messageId,
                              kWebSocketMsgType:messageType};
    
    [self sendDataWithObject:object];
    return messageId;
}

- (void)sendDataWithBody:(NSString *)body {
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@"send data %@", body]];
    [_webSocket sendString:body error:NULL];
    [self append:body type:1];
}

- (void)sendDataWithObject:(NSObject *)object {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendDataWithBody:string];
}

- (void)analyzeMessage:(id)message {
    if ([message isKindOfClass:[NSDictionary class]]) {
        NSDictionary *info = message;
        NSString *msgType = [info objectForKey:kWebSocketMsgType];
        NSString *notificationName = nil;
        //Device
        if ([msgType isEqualToString:kWebSocketMessageTypeBindDevice]) {
            notificationName = kWebSocketDidReceiveBindDeviceResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeUnBindDevice]) {
            notificationName = kWebSocketDidReceiveUnBindDeviceResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeDeviceOnline]) {
            notificationName = kWebSocketDidReceiveDeviceOnlineResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeDeviceRunStatus]) {
            notificationName = kWebSocketDidReceiveDeviceRunStatusResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeRegisterDevice]) {
            notificationName = kWebSocketDidReceiveRegisterDeviceResponseNotification;
        }
        else if ([msgType isEqualToString:kWebsocketMessageTypeDeviceChange]) {
            notificationName = kWebSocketDidReceiveDeviceChangeResponseNotification;
        }
        else if ([msgType isEqualToString:kWebsocketMessageTypeTempPasswordChange]) {
            notificationName = kWebSocketDidReceiveTempPasswordChangeResponseNotification;
        }
        //Authorize
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityAccept]) {
            notificationName = kWebSocketDidReceiveAuthorityAcceptResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityGrant]) {
            notificationName = kWebSocketDidReceiveAuthorityGrantResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityReject]) {
            notificationName = kWebSocketDidReceiveAuthorityRejectResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityRemove]) {
            notificationName = kWebSocketDidReceiveAuthorityRemoveResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityRevoke]) {
            notificationName = kWebSocketDidReceiveAuthorityRevokeResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAuthorityEdit]) {
            notificationName = kWebSocketDidReceiveAuthorityEditResponseNotification;
        }
        //Video Call
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoHangUp]) {
            notificationName = kWebSocketDidReceiveVideoHangUpResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoCall]) {
            notificationName = kWebSocketDidReceiveVideoCallResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoEnd]) {
            notificationName = kWebSocketDidReceiveVideoEndResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoAccepted]) {
            notificationName = kWebSocketDidReceiveVideoAcceptedResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoPickUp]) {
            notificationName = kWebSocketDidReceiveVideoPickUpResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeVideoCallOpenDoor]) {
            notificationName = kWebSocketDidReceiveVideoOpenDoorResponseNotification;
        }
        //group
        else if ([msgType isEqualToString:kWebSocketMessageTypeGroupChange]) {
            notificationName = kWebSocketDidReceiveGroupChangeResponseNotification;
        }
        //User
        else if ([msgType isEqualToString:kWebSocketMessageTypeUserLogin]) {
            notificationName = kWebSocketDidReceiveUserLoginResponseNotification;
        }
        //Alarm
        else if ([msgType isEqualToString:kWebSocketMessageTypeAlarmNotify]) {
            notificationName = kWebSocketDidReceiveAlarmNotifyResponseNotification;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeAlarmDelete]) {
            notificationName = kWebSocketDidReceiveAlarmDeleteResponseNotification;
        }
        //Control
        else if ([msgType isEqualToString:kWebSocketMessageTypeControl]) {
            notificationName = kWebSocketDidReceiveControlResponseNotification;
        }
        //Scenario
        else if ([msgType isEqualToString:kWebSocketMessageTypeScenarioChange]) {
            notificationName = kWebSocketDidReceiveScenarioChangeResponseNotification;
        } else if ([msgType isEqualToString:kWebSocketMessageTypeRoomScenarioChange]) {
            notificationName = kWebSocketDidReceiveRoomScenarioChangeResponseNotification;
        } else if ([msgType isEqualToString:kWebSocketMessageTypeLocationScenarioSwitched]) {
            notificationName = kWebSocketDidReceiveLocationScenarioSwitchedResponseNotification;
        } else if ([msgType isEqualToString:kWebSocketMessageTypeScenario] ||
                   [msgType isEqualToString:kWebSocketMessageTypeScenario_v2]||
                   [msgType isEqualToString:kWebSocketMessageTypeRoomScenario]) {
            notificationName = kWebSocketDidReceiveLocationScenarioResponseNotification;
        }else if ([msgType isEqualToString:kWebSocketMessageTypeRoomScenarioEdit]){
             notificationName = kNotification_ScenarioControl;
        }
        //Schedule
        else if ([msgType isEqualToString:kWebSocketMessageTypeScheduleChange]) {
            notificationName = kWebSocketDidReceiveScheduleChangeResponseNotificaiton;
        } else if ([msgType isEqualToString:kWebSocketMessageTypeScheduleExecuted]) {
            notificationName = kWebSocketDidReceiveLocationScheduleExecutedResponseNotificaiton;
        }
        //Trigger
        else if ([msgType isEqualToString:kWebSocketMessageTypeTriggerChange]) {
            notificationName = kWebSocketDidReceiveTriggerChangeResponseNotificaiton;
        }
        else if ([msgType isEqualToString:kWebSocketMessageTypeTriggerExecuted]) {
            notificationName = kWebSocketDidReceiveTriggerExecutedResponseNotificaiton;
        }
        //Location
        else if ([msgType isEqualToString:kWebsocketMessageTypeLocationChange]) {
            notificationName = kWebsocketDidReceiveLocationChangeNotification;
        }
        //event
        else if ([msgType isEqualToString:kWebsocketMessageTypeEventNew]) {
            notificationName = kWebsocketDidReceiveEventNewNotification;
        }
        else if ([msgType isEqualToString:kWebsocketMessageTypeEventChange]) {
            notificationName = kWebsocketDidReceiveEventChangeNotification;
        }
        if (notificationName) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:message];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidReceiveResponseNotification object:self userInfo:message];
    }
    [self append:message type:2];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self.state = WebSocketStateConnected;
    [TimerUtil cancelTimerWithName:kTimerNameUpdateLanguage];
    [LogUtil Debug:@"Websocket" message:@"Websocket Connected"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@":( Websocket Failed With Error %@", error]];
    if (error.code == NSURLErrorClientCertificateRejected) {
        [self swtichProdutionCert];
    }
    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string {
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@"receive string %@", string]];
    if (string.length > 0) {
        id object = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        if (object) {
            [self analyzeMessage:object];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(nonnull NSData *)data {
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@"receive data %@", data]];
    if (data.length > 0) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        if (object) {
            [self analyzeMessage:object];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@"WebSocket closed: %@", reason]];
    switch (code) {
        case HWErrorWebSocketUserBeenKicked:
        case HWErrorWebSocketUserLoginOnOtherDevice:
        {
            NSString *errorMsg = NSLocalizedString(@"account_pop_kickedout", nil);
            [[UserEntity instance] logoutWithAlertErrorMessage:errorMsg completion:nil];
            break;
        }
        case HWErrorLoginWrongUserNameOrPassword:
        {
            [[UserEntity instance] logoutWithAlertErrorMessage:nil completion:nil];
            break;
        }
        default:
            //other error occurs, will try to reconnect to websocket
            [self reconnect];
            break;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *pong = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    [LogUtil Debug:@"Websocket" message:[NSString stringWithFormat:@"Websocket received pong %@",pong]];
}

#pragma mark - getter
- (HWUpdateLanguageManager *)updateLanguageManager {
    if (!_updateLanguageManager) {
        _updateLanguageManager = [[HWUpdateLanguageManager alloc] init];
    }
    return _updateLanguageManager;
}

@end
