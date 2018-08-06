//
//  HZKitMacro.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#ifndef HZKitMacro_h
#define HZKitMacro_h

// TODO: 待完善

#pragma mark NLocalized
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

#endif /* HZKitMacro_h */
