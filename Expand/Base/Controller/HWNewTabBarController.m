//
//  HWNewTabBarController.m
//  Platform
//
//  Created by HoneyWell on 2020/4/13.
//

#import "HWNewTabBarController.h"
#import "AuthenticationManager.h"
#import "HWFingerPrintView.h"
#import "HWPatternVerifyView.h"
#import "HWUpdateLanguageManager.h"
#import "AppMarco.h"
#import "WebSocketManager.h"

#import "Reachability.h"
#import "HWWarningView.h"
#import "HWAlarmModel.h"
#import "HWWindowManager.h"
#import "EventModel.h"
#import "HWNotificationObject.h"
#import "HWVersionModel.h"
#import "NetworkUtil.h"
#import "DateTimeUtil.h"
#import "HWTabBarItem.h"
#import "HomeManager.h"

#import "HWNewDashboardViewController.h"
#import "HWAutomationViewController.h"
#import "MeViewController.h"
#import "HWNavigationController.h"
#import "HWDebugViewController.h"
#import "HWDebugButton.h"
#import "HWDebugButtonContainer.h"
#import "AppDelegate.h"
#define kTabbarItemBadgeTag 888
@interface HWNewTabBarController ()<IContainerViewControllerDelegate>
@property (nonatomic,strong) HWDebugButtonContainer *debugButtonContainer;
@property (nonatomic,strong) HWNewDashboardViewController * dashboard;
@end

@implementation HWNewTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViewControllers];
    [self loadData];
}
- (void)setupViewControllers{
        [self toggleDebugButton];
      NSArray *titles = nil, *normalImages = nil, *selectedImages = nil, *tags = nil;
      
      HomeManager *homeManager = [[HomeManager alloc] init];
    HWNewDashboardViewController * dashVc = [[HWNewDashboardViewController alloc]initWithNibName:@"HWNewDashboardViewController" bundle:nil];
    self.dashboard = dashVc;
    dashVc.homeManager = homeManager;
    dashVc.showNoNetwork = YES;
    HWNavigationController * dashboardVc = [[HWNavigationController alloc]initWithRootViewController:dashVc];
     HWNavigationController * autoVc = [[HWNavigationController alloc]initWithRootViewController:[[HWAutomationViewController alloc] initWithNibName:@"HWAutomationViewController" bundle:nil]];
     HWNavigationController * meVc = [[HWNavigationController alloc]initWithRootViewController:[[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil]];
      
     
      
          titles = @[NSLocalizedString(@"common_dashboard", nil),
                     NSLocalizedString(@"common_automation", nil),
                     NSLocalizedString(@"common_me", nil)];
          normalImages = @[@"dashboard_inactive",@"autoamtion_inactive",@"Me_inactive"];
          selectedImages = @[@"dashboard_active",@"autoamtion_active",@"Me_active"];
      
    [self addChildViewController:dashboardVc];
    [self addChildViewController:autoVc];
    [self addChildViewController:meVc];
          tags = @[@(HWTabBarItemTagDashboard),
                   @(HWTabbarItemTagAutomation),
                   @(HWTabBarItemTagMe)];
      
      NSMutableArray *items = [NSMutableArray array];
      for (NSInteger i = 0; i < [titles count]; i++) {
          NSString *title = titles[i];
          UIImage *normalImage = [[UIImage imageNamed:normalImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
          UIImage *selectedImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
          HWTabBarItem *item = [[HWTabBarItem alloc] initWithTitle:title image:normalImage tag:[tags[i] integerValue]];
          [item setTitleTextAttributes:@{NSFontAttributeName:[HWFont systemFontOfSize:12]} forState:UIControlStateNormal];
          item.itemType = HWTabBadgeTypeNone;
          item.selectedImage = selectedImage;
          [items addObject:item];
          
      }
    dashboardVc.tabBarItem = items[0];
    autoVc.tabBarItem = items[1];
    meVc.tabBarItem = items[2];
     
      [self updateVersonBadge];
      
      HWUpdateLanguageManager *manager = [[HWUpdateLanguageManager alloc] init];
      NSString *osLanguage = [AppConfig getLanguage];
      if ([osLanguage isEqualToString:@"en"]) {
          osLanguage = @"en_us";
      } else if ([osLanguage isEqualToString:@"zh"]) {
          osLanguage = @"zh_cn";
      }
      NSDictionary *param = @{@"osLanguage":osLanguage};
      [manager callAPIWithParam:param completion:^(id object, NSError *error) {
          WebSocketManager *ws = [WebSocketManager instance];
          if (ws.state == WebSocketStateInvalid) {
              [ws connect];
          }
      }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self setSelectedIndex:0];
       });
    
}
- (void)loadData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kNotification_LoginStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVideoCall:) name:kVideoCallHasCallIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketUserLogin:) name:kWebSocketDidReceiveUserLoginResponseNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlarmWebSocket:) name:kWebSocketDidReceiveAlarmNotifyResponseNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAuthen) name:@"StartAuthentication" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAuthenticationStatus) name:kNotification_AuthenticationStatusRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEvent:) name:kWebsocketDidReceiveEventNewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAction:) name:@"NotificationDidReceiveAction" object:nil];
    
    [[UserEntity instance] refreshUserEntity:YES];
    [self refreshAuthenticationStatus];
    
    WebSocketManager *ws = [WebSocketManager instance];
    if (ws.state == WebSocketStateInvalid) {
        [ws connect];
    }
}
- (void)refreshAuthenticationStatus {
    switch ([[AuthenticationManager instance] authenticationStatus]) {
        case AuthenticationStatusInvalid:
//            [self loadLanchingImage];
            [self goWelcomeVc];
            break;
        case AuthenticationStatusAuthenticating:
        {
//            [self removeLanchingImage];
//            [self loadTabBar];
        }
            break;
        case AuthenticationStatusFailed:
        {
//            [self setupLoginPage];
//            [self showUserLoginVCAnimated:NO];
        }
            break;
        case AuthenticationStatusAuthenticated:
        {
//            [self removeLanchingImage];
//            if (!self.loadTabbar) {
//                [self loadTabBar];
//            }
//            [self setup];
//            if ([self.pushNotificationObject.jumpPages count] > 0) {
//                [self triggerPushNotification];
//            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification 
- (void)webSocketUserLogin:(NSNotification *)notification {
    if ([[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusAuthenticated ||
        [[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusFailed) {
        NSDictionary *info = [notification userInfo];
        if ([[info allKeys] containsObject:@"errorCode"]) {
            if ([info[@"errorCode"] integerValue] == HWErrorWebSocketUserBeenKicked) {
                if ([[UserEntity instance] status] == UserStatusLogin) {
                    NSString *errorMsg = NSLocalizedString(@"account_pop_kickedout", nil);
                    [[UserEntity instance] logoutWithAlertErrorMessage:errorMsg completion:nil];
                }
            }
        }
    }
}
- (void)goWelcomeVc{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                  [delegate checkLoginStatus];
}
- (void)didReceiveAction:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSString *action = userInfo[@"actionIdentifier"];
    if ([action isEqualToString:@"action-call"]) {
        [self callContact];
    }
}

- (void)triggerPushNotification {
    AuthenticationManager *manager = [AuthenticationManager instance];
    if (!([manager authenticationStatus] == AuthenticationStatusAuthenticated)) {
        return;
    }
    if (self.pushNotificationObject.isKnownType) {
        //  not login state
        //  jump to login page
        //  login
        //  jump to message page
        //  在点弹框的See detail按钮的时候，需要判断该设备是否还存在，如果存在，跳转到设备控制页，如果不存在，该弹框消失，弹出另外一个框，告诉用户该设备已经被删除。
        if ([UserEntity instance].status == UserStatusLogin) {
            if (![self.pushNotificationObject.messageType isEqualToString: kWebSocketMessageTypeAlarmDelete]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    if (self.pushNotificationObject) {
                        [self jumpToPageURI];
                    }
                });
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DeleteAlarm object:nil];
            }
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [[MessageBox instance] showNormalAlertViewWithTitle:nil message:NSLocalizedString(@"msg_pop_msgrequirenewerapp", nil) buttonTitles:@[NSLocalizedString(@"common_cancel", nil),NSLocalizedString(@"common_update", nil)] redIndexs:nil finishCallback:^(NSInteger selectIndex) {
            if (selectIndex == 1) {
                [weakSelf gotoNewV];
            }
        }];
        self.pushNotificationObject = nil;
    }
}

- (void)showErrorMessage:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    if ([[info allKeys] containsObject:@"message"]) {
        [[HWMessageBox instance] showError:info[@"message"]];
    }
}
- (void)showAlarmWebSocket:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if ([[userInfo allKeys] containsObject:@"msgData"] && [[userInfo[@"msgData"] allKeys] containsObject:@"alarms"]) {
        if ([userInfo[@"msgData"][@"alarms"] isKindOfClass:[NSArray class]] && [userInfo[@"msgData"][@"alarms"] count] > 0) {
            if ([[UserEntity instance] status] == UserStatusLogin) {
                for (NSInteger i = [userInfo[@"msgData"][@"alarms"] count]-1; i>= 0; i--) {
                    NSDictionary *alarmDict = userInfo[@"msgData"][@"alarms"][i];
                    if ([[alarmDict objectForKey:@"isPopUp"] boolValue]) {
                        HWAlarmModel *model = [[HWAlarmModel alloc] initWithDictionary:alarmDict];
                        [self showAlarmWithAlarmModel:model];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GetAlarmNofity object:self userInfo:userInfo[@"msgData"][@"alarms"]];
            }
        }
    }
}

- (void)showAlarmWithAlarmModel:(id)model {
    if (![model isKindOfClass:[HWAlarmModel class]] &&
        ![model isKindOfClass:[EventModel class]]) {
        return;
    }
    if ([model isKindOfClass:[EventModel class]]) {
        EventModel *eventModel = (EventModel *)model;
        if (![model isPopUp]) {
            return;
        }
        [[UserEntity instance] readEventWithEventId:eventModel.eventId locationId:eventModel.locationId];
    }
}

- (void)showMessage:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    if ([[userInfo allKeys] containsObject:@"msgData"] && [[userInfo[@"msgData"] allKeys] containsObject:@"content"]) {
        if ([[UserEntity instance] status] == UserStatusLogin) {
            NSString *content = userInfo[@"msgData"][@"content"];
            if (content) {
                [[HWMessageBox instance] show:content];
            }
        }
        
    }
}

- (void)showEvent:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    if ([[userInfo allKeys] containsObject:@"msgData"] && [[userInfo[@"msgData"] allKeys] containsObject:@"events"]) {
        NSArray *events = userInfo[@"msgData"][@"events"];
        if (events.count > 0) {
            NSMutableDictionary *eventInfo = [NSMutableDictionary dictionaryWithDictionary:events.firstObject];
            [eventInfo setObject:@(YES) forKey:@"autoTrigger"];
            if ([[UserEntity instance] status] == UserStatusLogin) {
                [self showViewController:HWPageShowEvent object:eventInfo animation:YES];
            }
        }
    }
}

- (void)loginStatusChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    if (![[info objectForKey:@"SameUser"] boolValue]) {
        self.pushNotificationObject = nil;
    }
    BOOL showAlert = NO;
    NSString *errorMsg = [info objectForKey:@"errorMsg"];
    if (errorMsg.length > 0) {
        showAlert = YES;
    }
//    if (showAlert) {
//        [RouterManager sharedInstance].delegate = self;
//        [[RouterManager sharedInstance] popToIndex:0 animated:NO];
//        [self setupLoginPage];
//        [MessageBox dismissAllAlert];
//        [[MessageBox instance] showNormalAlertViewWithTitle:nil message:errorMsg buttonTitles:@[NSLocalizedString(@"common_ok", nil)] redIndexs:nil finishCallback:^(NSInteger selectIndex) {
//        }];
//        [self signIn:nil];
//    } else {
//        [self setup];
//    }
}

#pragma mark - Jumping Page
- (void)jumpToPageURI {
    for (NSNumber *typeNumber in self.pushNotificationObject.jumpPages) {
        BOOL animation = NO;
        if ([typeNumber isEqualToNumber:[self.pushNotificationObject.jumpPages lastObject]]) {
            animation = YES;
        }
        id object = nil;
        switch ([typeNumber integerValue]) {
            case HWPageDeviceControl:{
                HomeModel *home = [[UserEntity instance]getHomebyId:self.pushNotificationObject.locationId];
                object = [home getDeviceById:_pushNotificationObject.deviceId];
                break;
            }
            case HWPageLocation:{
                object = self.pushNotificationObject.locationId;
                break;
            }
            case HWPageMessageDetail:{
                object = @{@"messageId":@(self.pushNotificationObject.messageID),@"messageCategory":@(self.pushNotificationObject.messageCategory)};
                break;
            }
            case HWPageShowAlarm: {
                NSDictionary *msgData = self.pushNotificationObject.msgData;
                if ([msgData[@"alarms"] count] > 0) {
                    object = msgData[@"alarms"][0];
                }
                break;
            }
            case HWPageShowEvent: {
                NSDictionary *msgData = self.pushNotificationObject.msgData;
                if ([msgData[@"events"] count] > 0) {
                    object = msgData[@"events"][0];
                }
                break;
            }
            default:
                break;
        }
       [self showViewController:[typeNumber integerValue] object:object animation:animation];
    }
    self.pushNotificationObject = nil;
}

- (void)setup {
    
    UserEntity *userEntity = [UserEntity instance];
    if ([[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusAuthenticated || [[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusFailed) {
        if (userEntity.status == UserStatusLogin) {
//            [self setupTabBarController];
//        } else {
//            [self setupLoginPage];
        }
    }
}

- (void)checkVInForground:(BOOL)isForground {
    __weak typeof(self) weakSelf = self;
    [[HWVersionModel instance] checkV:isForground result:^(NSDictionary *updateDic, BOOL isForceUpdate, BOOL handleNow) {
        [weakSelf updateVersonBadge];
        if (handleNow) {
            [weakSelf pushNewVAlert:updateDic needForceUpdate:isForceUpdate];
        }
    }];
}

-(void)applicationEnterForeground
{
    if ([NetworkUtil isReachable]) {
        [self checkVInForground:YES];
    }
}

- (void)reachabilityChanged:(NSNotification *)notification {
    if ([NetworkUtil isReachable]) {
        [self checkVInForground:NO];
    }
}

#pragma mark - go to app store to update
- (void)gotoNewV {
    [AppConfig setPopNewVTime:nil];
    NSString *urlString = [HWVersionModel instance].appURL;
    NSURL *url = [NSURL URLWithString:urlString];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8", APPSTOREAPPID]];
    [[UIApplication sharedApplication] openURL:url];
    if ([urlString hasPrefix:@"itms-services://"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HWMessageBox instance] show:NSLocalizedString(@"common_iosbetaupdatehint", nil) timeout:CGFLOAT_MAX style:HWMessageBoxStyleBlue dismissing:YES];
        });
    }
}

-(void)pushNewVAlert:(NSDictionary *)appInfo needForceUpdate:(BOOL)pForceUpdate
{
    NSString * nowVersion= @"";
    if ([[appInfo allKeys] containsObject:@"displayversion"]) {
        nowVersion=[appInfo objectForKey:@"displayversion"];
    }
    NSString *releaseNote=@"";
    NSString *releaseKey=[AppConfig isEnglish]?@"releasenotesen":@"releasenotescn";
    if ([[appInfo allKeys] containsObject:releaseKey]) {
        releaseNote=[appInfo objectForKey:releaseKey];
    }
    
    NSString *title=[NSString stringWithFormat:NSLocalizedString(@"common_foundnewversion", nil),nowVersion];
    NSString *content=releaseNote;
    NSArray *titleArray = nil;
    if (pForceUpdate) {
        titleArray = @[NSLocalizedString(@"common_update", nil)];
    } else {
        titleArray = @[NSLocalizedString(@"common_later", nil),NSLocalizedString(@"common_update", nil)];
    }
    static int newVTag = 192874;
    [MessageBox dismissAlertWithTag:newVTag];
    __weak typeof(self) weakSelf = self;
    HWNormalAlertView *alert = [[MessageBox instance] showNormalAlertViewWithTitle:nil message:[NSString stringWithFormat:@"%@\n%@",title,content] buttonTitles:titleArray redIndexs:nil finishCallback:^(NSInteger selectIndex) {
        if (pForceUpdate) {
            [weakSelf gotoNewV];
            self.view.userInteractionEnabled = NO;
        } else {
            if (selectIndex == 0) {
                [AppConfig setPopNewVTime:[[DateTimeUtil instance] getNowDateTimeString]];
            } else {
                [weakSelf gotoNewV];
            }
        }
    }];
    alert.tag = newVTag;
}

- (void)updateVersonBadge {
    HWVersionModel *model = [HWVersionModel instance];
    if ([model showTabbarBadge]) {
        [self badgeType:HWTabBadgeTypeNew onIndex:HWTabBarItemTagMe];
    } else {
        [self badgeType:HWTabBadgeTypeNone onIndex:HWTabBarItemTagMe];
    }
}

#pragma mark - Badg
//显示小红点
- (void)showBadgeOnItemIndex:(HWTabBarItemTag)index type:(HWTabBadgeType)type {
    HWTabBarItem * tabBarItem = [self getItemWithIndex:index];
    if (tabBarItem == nil) {
        return;
    } else {
        if (tabBarItem.itemType == type) {
            return;
        }
        //移除之前的小红点
        [self removeBadgeOnItemIndex:index];
        
        //新建小红点
        UIImageView *badgeView = [[UIImageView alloc]init];
        badgeView.tag = kTabbarItemBadgeTag + index;
        
        float iconWidth = 7;
        switch (type) {
            case HWTabBadgeTypeNew:
            {
                [badgeView setImage:[UIImage imageNamed:@"tab_small_red_dot.png"]];
            }
                break;
            case HWTabBadgeTypeError:
            {
                [badgeView setImage:[UIImage imageNamed:@"tab_alert.png"]];
                iconWidth = 10;
            }
                break;
            default:
                break;
        }
        
        NSArray * itemsArray = self.tabBar.items;
        CGRect tabFrame = self.tabBar.frame;
        float itemWidth = tabFrame.size.width/itemsArray.count;
        
        NSInteger itemIndex = 0;
        for (NSInteger i = 0; i < itemsArray.count; i ++) {
            HWTabBarItem * item = [itemsArray objectAtIndex:i];
            if (item.tag == index) {
                itemIndex = i;
            }
        }
        
        //确定小红点的位置
        float percentX = (float)itemIndex / (float)itemsArray.count;
        CGFloat x = ceilf(percentX * tabFrame.size.width)+itemWidth/2+18*WidthScaleBase47Inch;
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, iconWidth, iconWidth);//圆形大小为7
        [self.tabBar addSubview:badgeView];
        
        tabBarItem.itemType = type;
    }
}
- (void)badgeType:(HWTabBadgeType)type onIndex:(HWTabBarItemTag)index {
    switch (type) {
        case HWTabBadgeTypeNone:
        {
            [self hideBadgeOnItemIndex:index];
        }
            break;
        case HWTabBadgeTypeNew:
        case HWTabBadgeTypeError:
        default:
            [self showBadgeOnItemIndex:index type:type];
            break;
    }
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSUInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSUInteger)index{
    HWTabBarItem * item = [self getItemWithIndex:index];
    item.itemType = HWTabBadgeTypeNone;
    //按照tag值进行移除
    for (UIView *subView in self.tabBar.subviews) {
        if (subView.tag == kTabbarItemBadgeTag+index) {
            [subView removeFromSuperview];
        }
    }
}

- (HWTabBarItem *)getItemWithIndex:(HWTabBarItemTag)index {
    HWTabBarItem * tabBarItem = nil;
    NSArray * itemsArray = self.tabBar.items;
    for (NSInteger i = 0; i < itemsArray.count; i ++) {
        HWTabBarItem * item = [itemsArray objectAtIndex:i];
        if (item.tag == index) {
            tabBarItem = item;
        }
    }
    return tabBarItem;
}


#pragma mark - Debug
- (void)toggleDebugButton {
    
    if (SHOW_DEBUG_BUTTON) {
        if (!_debugButtonContainer) {
            _debugButtonContainer = [[HWDebugButtonContainer alloc] initWithFrame:SCREENBOUNDS];
            _debugButtonContainer.delegate = self;
            [self.view addSubview:_debugButtonContainer];
        }
        
    }else{
        [_debugButtonContainer removeFromSuperview];
               _debugButtonContainer = nil;
    }
}
- (void)showDebugViewController {
    
        [self.viewControllers[self.selectedIndex] pushViewController:[[HWDebugViewController alloc] initWithNibName:@"HWDebugViewController" bundle:nil] animated:YES];
    
}


@end
