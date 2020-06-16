//
//  AppManager.m
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "AppManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "TTTAttributedLabel.h"
#import "ChinaEnterprise.h"
#import "ChinaPersonal.h"
#import "IndiaPersonal.h"
#import "UserEntity.h"
#import "LocationManager.h"
#import "AppMarco.h"

static ChinaEnterprise *enterprise = nil;
static ChinaPersonal *china = nil;
static IndiaPersonal *india = nil;


@implementation AppManager

+ (id<LocalizationProtocol>)getLocalProtocol {
    if ([UserEntity instance].isEnterprise) {
        if (enterprise == nil) {
            enterprise = [[ChinaEnterprise alloc] init];
        }
        return enterprise;
    } else {
        return [self getPersonalProtocol];
    }
}

+ (id<LocalizationProtocol>)getPersonalProtocol
{
    if (china == nil) {
        china = [[ChinaPersonal alloc] init];
    }
    if (india == nil) {
        india = [[IndiaPersonal alloc] init];
    }
    UserEntity * userEntity = [UserEntity instance];
    UserStatus userStatus = userEntity.status;
    if (userStatus == UserStatusLogin) {
        NSString * telephoneCode = userEntity.countryPhoneNum;
        if ([telephoneCode isEqualToString:@"91"]) {
            return india;
        }
        return china;
    } else {
        LocationManager * locationManager = [LocationManager shareLocationManager];
        NSString *locationISOCountryCode = locationManager.ISOcountryCode;
        
        NSLocale *locale = [NSLocale currentLocale];
        NSString *localeISOCountryCode = [locale objectForKey:NSLocaleCountryCode];
        
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *carrierISOCountryCode = [[carrier isoCountryCode] uppercaseString];
        
        if ([locationISOCountryCode isEqualToString:@"IN"]
            || [localeISOCountryCode isEqualToString:@"IN"]
            || [carrierISOCountryCode isEqualToString:@"IN"]) {
            return india;
        }
        
        return china;
    }
}

+ (void)configSMSTermLabel:(TTTAttributedLabel *)label {
    NSString *term1 = NSLocalizedString(@"account_lbl_term1", nil);
    NSString *term2 = NSLocalizedString(@"account_lbl_term2", nil);
    NSString *term3 = NSLocalizedString(@"common_full_stop", nil);
    NSString *termString = [NSString stringWithFormat:@"%@%@%@",term1,term2,term3];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.25 * label.font.lineHeight;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : label.textColor,
                                 NSFontAttributeName : label.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:termString
                                                                    attributes:attributes];
    
    label.backgroundColor = [UIColor clearColor];
    label.text = attString;
    label.preferredMaxLayoutWidth = label.frame.size.width;
    label.linkAttributes = @{NSForegroundColorAttributeName: (id)BlueButtonColor.CGColor,
                             NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    label.activeLinkAttributes = @{NSForegroundColorAttributeName: (id)BlueButtonColor.CGColor,
                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    [label addLinkToURL:[NSURL URLWithString:@"term://"] withRange:NSMakeRange(term1.length, term2.length)];
    label.numberOfLines = 0;
}

@end
