//
//  FoodDatabaseReader.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodDatabaseReader.h"

#import "DatabaseContext.h"
#import "Food.h"

#import "FoodCategory.h"
#import "FoodCategory+LocalizedViewModel.h"

@interface FoodDatabaseReader ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation FoodDatabaseReader

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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Food class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language == %@", locale];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                         ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"ocategoryid"
                                                                                   cacheName:NSStringFromClass([Food class])];
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

- (NSString*)getSectionTitleAtSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSInteger foodCategoryId = [sectionInfo.name integerValue];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"oid == %d", foodCategoryId];
    fetchRequest.predicate = predicate;
    
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!results
        || results.count == 0)
        return [NSString string];
    
    FoodCategory *foodCategory = results[0];
    return foodCategory.localizedName;
}

@end
