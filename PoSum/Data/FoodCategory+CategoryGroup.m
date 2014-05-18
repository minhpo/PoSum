//
//  FoodCategory+CategoryGroup.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodCategory+CategoryGroup.h"

@implementation FoodCategory (CategoryGroup)

- (NSString*)group {
    return [self.category substringWithRange:NSMakeRange(0, 1)];
}

@end
