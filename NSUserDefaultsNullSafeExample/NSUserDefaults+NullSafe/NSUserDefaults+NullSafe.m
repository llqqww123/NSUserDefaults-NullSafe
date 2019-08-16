//
//  NSUserDefaults+NullSafe.m
//  XiaoQiHui
//
//  Created by 雷琦玮 on 2019/8/15.
//  Copyright © 2019 XiaoQiHui. All rights reserved.
//

#import "NSUserDefaults+NullSafe.h"
#import <objc/runtime.h>

@implementation NSUserDefaults (NullSafe)

+ (void)load
{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        Method originalMethod = class_getInstanceMethod(class, @selector(setObject:forKey:));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(wins_setObject:forKey:))
        ;
        BOOL didAddMethod = class_addMethod(class, @selector(setObject:forKey:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, @selector(wins_setObject:forKey:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)wins_setObject:(nullable id)value forKey:(NSString *)defaultName
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *newDictionary = [self removeNullValueWithOriginalDictionary:value];
        NSLog(@"Class: NSUserDefaults (NullSafe), newDictionary: %@", newDictionary);
        [self wins_setObject:newDictionary forKey:defaultName];
        return;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *newArray = [self removeNullValueWithOriginalArray:value];
        NSLog(@"Class: NSUserDefaults (NullSafe), newArray: %@", newArray);
        [self wins_setObject:newArray forKey:defaultName];
        return;
    }
    [self wins_setObject:value forKey:defaultName];
}

- (NSDictionary *)removeNullValueWithOriginalDictionary:(NSDictionary *)originalDictionary
{
    NSMutableDictionary *newDictionary = @{}.mutableCopy;
    for (NSString *key in originalDictionary.allKeys) {
        if ([originalDictionary[key] isKindOfClass:[NSDictionary class]]) {
            newDictionary[key] = [self removeNullValueWithOriginalDictionary:originalDictionary[key]];
        }else if ([originalDictionary[key] isKindOfClass:[NSArray class]]) {
            newDictionary[key] = [self removeNullValueWithOriginalArray:originalDictionary[key]];
        }else if ([originalDictionary[key] isKindOfClass:[NSNull class]]) {
            newDictionary[key] = @"";
        }else {
            newDictionary[key] = originalDictionary[key];
        }
    }
    return newDictionary;
}

- (NSArray *)removeNullValueWithOriginalArray:(NSArray *)originalArray
{
    NSMutableArray *newArray = @[].mutableCopy;
    for (id object in originalArray) {
        if ([object isKindOfClass:[NSArray class]]) {
            [newArray addObject:[self removeNullValueWithOriginalArray:object]];
        }else if ([object isKindOfClass:[NSDictionary class]]) {
            [newArray addObject:[self removeNullValueWithOriginalDictionary:object]];
        }else if ([object isKindOfClass:[NSNull class]]) {
            [newArray addObject:@""];
        }else {
            [newArray addObject:object];
        }
    }
    return newArray;
}

@end
