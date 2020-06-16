//
//  HWNewTabBarController.h
//  Platform
//
//  Created by HoneyWell on 2020/4/13.
//

#import <UIKit/UIKit.h>

#import "IContainerViewControllerDelegate.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^pushTestBlock)();

@class HWNotificationObject;
@interface HWNewTabBarController : UITabBarController
@property (nonatomic, strong) HWNotificationObject *pushNotificationObject;

@property (nonatomic, copy) pushTestBlock pushTestBlock;
@property (nonatomic, assign) BOOL haveLoadTabbar;

//andy
- (void)showViewController:(HWPageType)type object:(id)object animation:(BOOL)animation;


- (void)loadData;

- (void)startUpdateWifiWithParam:(NSDictionary *)param;

- (void)callContact;
@end

NS_ASSUME_NONNULL_END
