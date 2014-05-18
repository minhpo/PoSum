//
//  FoodCategory+LocalizedViewModel.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodCategory+LocalizedViewModel.h"

@implementation FoodCategory (LocalizedViewModel)

- (NSString*)localizedGroup {
    return [[self.localizedName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
}

- (NSString*)localizedName {
    NSString *languageCode = [NSLocale preferredLanguages][0];
    
    SEL localizedNameSelector = NSSelectorFromString([NSString stringWithFormat:@"name_%@", languageCode]);
    NSString *localizedText = [self respondsToSelector:localizedNameSelector]
        ? [self performSelector:localizedNameSelector]
        : self.category;
    
    if (localizedText.length < 1)
        localizedText = self.category;
    
    return localizedText;
}

@end
