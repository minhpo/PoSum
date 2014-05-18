//
//  NSObject+NSDictionary.m
//  LocAwarePOC
//
//  Created by Po Sam on 07/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "NSObject+NSDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (NSDictionary)

- (NSDictionary*)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        // Only add to the NSDictionary if it's not nil.
        if (value) {
            if ([value isKindOfClass:[NSDate class]]) {
                NSNumber *unixTimeStamp = [NSNumber numberWithDouble:[(NSDate*)value timeIntervalSince1970]];
                [dictionary setObject:unixTimeStamp forKey:key];
            }
            else
                [dictionary setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return dictionary;
}

@end
