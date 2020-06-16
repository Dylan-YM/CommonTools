//
//  YMAPIConstant.h
//  Platform
//
//  Created by HoneyWell on 2020/4/7.
//

#ifndef YMAPIConstant_h
#define YMAPIConstant_h
//MARK:- 设置weakSelf
#define  WeakSelf  __weak __typeof(self)weakSelf = self;
#define localString(localNameString)  NSLocalizedString(localNameString, nil)
#ifdef DEBUG
#define YMLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__);
#define MyNSLog(FORMAT, ...) fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define DeBugLog(...)
#define NSLog(...)
#define MyNSLog(FORMAT, ...) nil
#endif
#define ManualLegalAccept  		 @"ManualLegalAccept"
#endif /* YMAPIConstant_h */
