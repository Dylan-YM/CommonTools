//
//  HWModeCellModel.h
//  AirTouch
//
//  Created by Wang, Devin on 6/29/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HWModeCellModel : NSObject
@property (strong, nonatomic) NSString *normalImageName;
@property (strong, nonatomic) NSString *selectedImageName;
@property (strong, nonatomic) NSString *abnormalImageName;
@property (strong, nonatomic) NSString *normalCircleImageName;
@property (strong, nonatomic) NSString *selectedNormalCircleImageName;
@property (strong, nonatomic) UIColor *normalTextColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) NSString *modeString;
@property (assign, nonatomic) NSInteger identifer;
@property (strong, nonatomic) id commandValue;

@end
