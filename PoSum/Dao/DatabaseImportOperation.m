//
//  DatabaseImportOperation.m
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "DatabaseImportOperation.h"
#import "DatabaseContext.h"

#import "Shared.h"

@interface DatabaseImportOperation ()

@property NSString *fileName;
@property (assign) Class targetClass;
@property (strong) ProgressCallback progressCallback;
@property (nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation DatabaseImportOperation

- (id)initWithFileName:(NSString*)fileName forClass:(Class)targetClass withProgressCallback:(ProgressCallback)progressCallback {
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.targetClass = targetClass;
        self.progressCallback = progressCallback;
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
    }
    
    return self;
}

- (void)main
{
    NSArray *ids = [self getIdsOfStoredObjects];
    
    NSError *error;
    NSArray *unfilteredArrayOfJsonObjects = [self loadJsonObjectsFromFile:self.fileName error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    NSArray *filteredArrayOfJsonObjects = [self getObjectsToBeImportedFromSource:unfilteredArrayOfJsonObjects
                                                                        filterByObjectsWithIds:ids];
    
    [self importObjects:filteredArrayOfJsonObjects];
}

- (NSArray*)getIdsOfStoredObjects {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self.targetClass)
                                              inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"oid"]];
    
    // Execute the fetch.
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray*)loadJsonObjectsFromFile:(NSString*)fileName error:(NSError**)error {
    NSString* fileContents = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:NULL];
    NSData *jsonData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arrayOfJsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];
    
    return arrayOfJsonObjects;
}

- (NSArray*)getObjectsToBeImportedFromSource:(NSArray*)source filterByObjectsWithIds:(NSArray*)ids {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(oid in %@)", [ids valueForKeyPath:@"oid"]];
    return [source filteredArrayUsingPredicate:predicate];
}

- (void)importObjects:(NSArray*)objects {
    static const int importBatchSize = 250;
    
    __block NSInteger counter = 0;
    __block NSInteger count = objects.count;
    
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id instance = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.targetClass)
                                                    inManagedObjectContext:self.managedObjectContext];
        [instance setValuesForKeysWithDictionary:obj];
        
        counter++;
        if (self.progressCallback
            && counter % importBatchSize == 0)
            self.progressCallback(counter / (float) count);
        
        if (counter % importBatchSize == 0)
            [self.managedObjectContext save:NULL];
        
    }];
    
    self.progressCallback(1);
    [self.managedObjectContext save:NULL];
}

@end
