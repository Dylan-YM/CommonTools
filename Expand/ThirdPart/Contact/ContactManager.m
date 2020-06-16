//
//  ContactManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 10/10/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "ContactManager.h"

@interface ContactManager()

@property (assign, nonatomic) ABAuthorizationStatus status;

@end

@implementation ContactManager

+ (ContactManager *)instance {
    static ContactManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ContactManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray *)readContactsWithQuery:(NSString *)query {
    ABAddressBookRef bookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(bookRef);
    CFIndex count = CFArrayGetCount(arrayRef);
    NSMutableArray *contacts = [NSMutableArray array];
    
    NSString *lowerCaseQuery = [query lowercaseString];
    for (int i = 0; i < count; i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(arrayRef, i);
        
        // 获取姓名
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        // 获取电话号码
        ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (int i = 0; i < count; i ++)
        {
            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            
            if (phone) {
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];//ascii space code: 0x20
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];//utf-8 space code: 0xc2 0xa0
                phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
                if ([phone hasPrefix:@"0086"]) {
                    phone = [phone substringFromIndex:4];
                }
                
                NSMutableDictionary *contact = [NSMutableDictionary dictionary];
                NSString *name = [NSString stringWithFormat:@"%@%@", firstName?:@"", lastName?:@""];
                NSString *reverseName = [NSString stringWithFormat:@"%@%@", lastName?:@"", firstName?:@""];
                
                if ([[phone lowercaseString] containsString:lowerCaseQuery]
                    ||[[name lowercaseString] containsString:lowerCaseQuery]
                    ||[[reverseName lowercaseString] containsString:lowerCaseQuery]) {
                    contact[@"name"] = name?:@"";
                    contact[@"phone"] = phone?:@"";
                    [contacts addObject:contact];
                }
                if ([contacts count] >= 10) {
                    break;
                }
                
            }
        }
        
        CFRelease(multiValue);
        if ([contacts count] >= 10) {
            break;
        }
    }
    CFRelease(bookRef);
    CFRelease(arrayRef);
    return [contacts copy];
}

- (void)readContactsWithQuery:(NSString *)query completion:(void(^)(NSArray *contacts, NSError *error))completion {
    self.status = ABAddressBookGetAuthorizationStatus();
    switch (self.status) {
        case kABAuthorizationStatusNotDetermined:{
            ABAddressBookRef bookRef = ABAddressBookCreate();
            __block NSString *queryCopy = query;
            ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
                CFRelease(bookRef);
                if (granted) {
                    NSArray *contacts = [self readContactsWithQuery:queryCopy];
                    if (completion) {
                        completion(contacts, nil);
                    }
                } else {
                    if (completion) {
                        completion(nil, [NSError errorWithDomain:@"获取通讯录失败，没有权限！" code:self.status userInfo:nil]);
                    }
                }
            });
            break;
        }
        case kABAuthorizationStatusAuthorized:{
            NSArray *contacts = [self readContactsWithQuery:query];
            if (completion) {
                completion(contacts, nil);
            }
            break;
        }
        default:{
            if (completion) {
                completion(nil, [NSError errorWithDomain:@"获取通讯录失败，没有权限！" code:self.status userInfo:nil]);
            }
            break;
        }
    }
    
}

@end
