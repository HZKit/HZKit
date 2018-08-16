//
//  HZKitMacro.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#ifndef HZKitMacro_h
#define HZKitMacro_h

#if DEBUG
    #define isDebug (YES)
#else
    #define isDebug (NO)
#endif

#pragma mark - NLocalized
#define HZLocalizedString(key, tbl) \
        [NSBundle.mainBundle localizedStringForKey:(@"" key) value:@"" table:(@"" tbl)]
#define HZShowLocalizedString(key) \
        [NSBundle.mainBundle localizedStringForKey:(@"" key) value:@"" table:@"HZShow"]
#define HZCCLocalizedString(key) \
        [NSBundle.mainBundle localizedStringForKey:(@"" key) value:@"" table:@"HZCustomControl"]
#define HZAboutLocalizedString(key) \
        [NSBundle.mainBundle localizedStringForKey:(@"" key) value:@"" table:@"HZAbout"]
#define HZAlertLocalizedString(key) \
        [NSBundle.mainBundle localizedStringForKey:(@"" key) value:@"" table:@"HZAlert"]

#pragma mark - Queue
#define HZ_MAIN_QUEUE(block) \
    if ([NSThread mainThread]) { \
        block(); \
    } else { \
        dispatch_async(dispatch_get_main_queue(), block()); \
    }


#pragma mark - Log
#ifndef HLog
    #if DEBUG
        #define HLog(fmt, ...) NSLog((@"%@ [line %u]: " fmt), NSStringFromClass(self.class), __LINE__, ##__VA_ARGS__)
    #else
        #define HLog(...)
    #endif
#endif


#endif /* HZKitMacro_h */
