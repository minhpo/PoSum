//
//  DatabaseContext.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseContext : NSObject

+ (DatabaseContext*)sharedInstance;

- (NSArray*)fetchAllIdsForClass:(Class)targetClass;
- (void)importInstances:(NSArray*)instances forClass:(Class)targetClass withProgressCallback:(void (^)(float))progress;

@end
