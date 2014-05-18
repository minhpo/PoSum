//
//  ExerciseDatabaseReader.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ExerciseDatabaseReader.h"

#import "DatabaseContext.h"
#import "Exercise.h"

@interface ExerciseDatabaseReader ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation ExerciseDatabaseReader

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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Exercise class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                         ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:NSStringFromClass([Exercise class])];
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

@end
