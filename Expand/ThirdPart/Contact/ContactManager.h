//
//  ContactManager.h
//  HomePlatform
//
//  Created by Liu, Carl on 10/10/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ContactManager : NSObject

+ (ContactManager *)instance;

- (void)readContactsWithQuery:(NSString *)query completion:(void(^)(NSArray *contacts, NSError *error))completion;

@end
