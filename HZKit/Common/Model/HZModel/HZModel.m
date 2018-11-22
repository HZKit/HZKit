//
//  HZModel.m
//  HZKit
//
//  Created by HertzWang on 2018/11/20.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZModel.h"

typedef NS_ENUM(NSUInteger, HZModelRuntimeOpeationType) {
    HZModelRuntimeOpeationCoder,
    HZModelRuntimeOpeationDecoder,
    HZModelRuntimeOpeationCopy,
};

@implementation HZModel

#pragma mark - Private
- (void)runtimeOpeationWithObject:(id)objc type:(HZModelRuntimeOpeationType)type {
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        
        if (type == HZModelRuntimeOpeationCoder) {
            NSCoder *aCoder = (NSCoder *)objc;
            [aCoder encodeObject:[self valueForKey:key] forKey:key];
        } else if (type == HZModelRuntimeOpeationDecoder) {
            NSCoder *aDecoder = (NSCoder *)objc;
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        } else if (type == HZModelRuntimeOpeationCopy) {
            id value = [self valueForKey:key];
            [objc setValue:value forKey:key];
        }
    }
    
    free(ivars);
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [self runtimeOpeationWithObject:aCoder type:HZModelRuntimeOpeationCoder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self runtimeOpeationWithObject:aDecoder type:HZModelRuntimeOpeationDecoder];
    }
    
    return self;
}

#pragma mark - NSCopying
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    
    id copyInstance = [[[self class] allocWithZone:zone] init];
    [self runtimeOpeationWithObject:copyInstance type:HZModelRuntimeOpeationCopy];

    return copyInstance;
}

@end

@implementation HZModel (JSON)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self && [dictionary isKindOfClass:[NSDictionary class]]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            if ([key hasPrefix:@"_"]) {
                key = [key substringFromIndex:1];
            }
            id value = [dictionary objectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
        free(ivars);
    }
    
    return self;
}

@end
