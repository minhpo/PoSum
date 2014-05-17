//
//  ImportOperation.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ImportOperation.h"

#import "DatabaseFiller.h"
#import "DatabaseContext.h"

@interface ImportOperation ()

@property DatabaseFiller *databaseFiller;

@end

@implementation ImportOperation

- (id)initWithFileName:(NSString*)name forClass:(Class)targetClass withProgressCallback:(void(^)(float))progressCallback {
    self = [super init];
    if(self) {
        self.databaseFiller = [DatabaseFiller new];
        self.databaseFiller.fileName = name;
        self.databaseFiller.targetClass = targetClass;
        self.databaseFiller.progressCallback = progressCallback;
        self.databaseFiller.database = [DatabaseContext sharedInstance];
    }
    return self;
}

- (void)main
{
    [self.databaseFiller startImportingData];
}

@end