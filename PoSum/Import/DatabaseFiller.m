//
//  DatabaseFiller.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "DatabaseFiller.h"
#import "DatabaseContext.h"

@implementation DatabaseFiller

- (void)startImportingData {
    NSArray *ids = [self getAllKnownIds];
    
    NSError *error;
    NSArray *unfilteredArrayOfJsonObjects = [self loadJsonObjectsFromFile:self.fileName error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    NSArray *filteredArrayOfJsonObjects = [self getObjectsToBeImportedFromSource:unfilteredArrayOfJsonObjects filterBy:ids];
    
    [self importObjects:filteredArrayOfJsonObjects];
}

- (NSArray*)getAllKnownIds {
    return [self.database fetchAllIdsForClass:self.targetClass];
}

- (NSArray*)loadJsonObjectsFromFile:(NSString*)fileName error:(NSError**)error {
    NSString* fileContents = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:NULL];
    NSData *jsonData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arrayOfJsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];
    
    return arrayOfJsonObjects;
}

- (NSArray*)getObjectsToBeImportedFromSource:(NSArray*)source filterBy:(NSArray*)filters {
    return [source filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(oid in %@)", [filters valueForKeyPath:@"oid"]]];
}

- (void)importObjects:(NSArray*)objects {
    [self.database importInstances:objects
                          forClass:self.targetClass
              withProgressCallback:^(float progress) {
                  if (self.progressCallback)
                      self.progressCallback(progress);
              }];
}

@end
