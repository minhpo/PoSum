//
//  DatabaseContentInitializer.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "DatabaseContentInitializer.h"
#import "DatabaseContext.h"

@interface DatabaseContentInitializer ()

@property (nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation DatabaseContentInitializer

- (id)init {
    self = [super init];
    if (self) {
        [self setupManagedObjectContext];
    }
    
    return self;
}

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
    return [self fetchAllIdsForClass:self.targetClass];
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
    [self importInstances:objects
                          forClass:self.targetClass
              withProgressCallback:^(float progress) {
                  if (self.progressCallback)
                      self.progressCallback(progress);
              }];
}

- (NSArray*)fetchAllIdsForClass:(Class)targetClass {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(targetClass) inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"oid"]];
    
    // Execute the fetch.
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:request error:&error];

}

- (void)importInstances:(NSArray*)instances forClass:(Class)targetClass withProgressCallback:(void (^)(float))progress {
    static const int importBatchSize = 250;
    
    __block NSInteger counter = 0;
    __block NSInteger count = instances.count;
    
    [instances enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id instance = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(targetClass)
                                                    inManagedObjectContext:self.managedObjectContext];
        [instance setValuesForKeysWithDictionary:obj];
        
        counter++;
        if (progress
            && counter % importBatchSize == 0)
            progress(counter / (float) count);
        
        if (counter % importBatchSize == 0)
            [self.managedObjectContext save:NULL];
        
    }];
    
    progress(1);
    [self.managedObjectContext save:NULL];
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

@end