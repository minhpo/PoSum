//
//  FoodCategoryDatabaseReader.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodCategoryDatabaseReader.h"

#import "DatabaseContext.h"

#import "FoodCategory.h"
#import "FoodCategory+CategoryGroup.h"

@interface FoodCategoryDatabaseReader ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation FoodCategoryDatabaseReader

- (id)init {
    self = [super init];
    if (self) {
        [self setupManagedObjectContext];
        [self setupFetchController];
    }
    
    return self;
}

- (void)setupFetchController {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"headcategoryid != %d", 15];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"category"
                                                         ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"group"
                                                                                   cacheName:NSStringFromClass([FoodCategory class])];
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

@end
