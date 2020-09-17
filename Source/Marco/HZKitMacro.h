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

// TODO: 完善常用宏

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
