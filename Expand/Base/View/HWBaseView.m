//
//  HWBaseView.m
//  Platform
//
//  Created by HoneyWell on 2020/4/13.
//

#import "HWBaseView.h"

@implementation HWBaseView

- (void)dealloc
{
    NSLog(@"<%@> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
     
}

@end
