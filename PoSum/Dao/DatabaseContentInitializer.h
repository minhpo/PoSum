//
//  DatabaseContentInitializer.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatabaseContext;

@interface DatabaseContentInitializer : NSObject

- (void)startImportingData;

@property (assign) Class targetClass;
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, copy) void (^progressCallback) (float);

@property DatabaseContext *database;

@end
