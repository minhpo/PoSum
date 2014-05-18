//
//  Exercise+LocalizedViewModel.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "Exercise+LocalizedViewModel.h"

@implementation Exercise (LocalizedViewModel)

- (NSString*)localizedName {
    NSString *languageCode = [NSLocale preferredLanguages][0];
    
    SEL localizedNameSelector = NSSelectorFromString([NSString stringWithFormat:@"name_%@", languageCode]);
    NSString *localizedText = [self respondsToSelector:localizedNameSelector]
    ? [self performSelector:localizedNameSelector]
    : self.title;
    
    if (localizedText.length < 1)
        localizedText = self.title;
    
    return localizedText;
}

@end
