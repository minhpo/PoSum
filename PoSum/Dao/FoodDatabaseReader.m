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
    }
    
    return self;
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

- (void)fetchResultForSearchTerm:(NSString*)searchTerm {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Food class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
    NSPredicate *predicate = !searchTerm || [searchTerm isEqualToString:[NSString string]]
        ? [NSPredicate predicateWithFormat:@"language == %@", locale]
        : [NSPredicate predicateWithFormat:@"language == %@ AND title contains[c] %@", locale, searchTerm];
    fetchRequest.predicate = predicate;
    
    NSString *sortKey = !searchTerm || [searchTerm isEqualToString:[NSString string]]
        ? @"ocategoryid"
        : @"title";
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                         ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSString *sectionNameKeyPath = !searchTerm || [searchTerm isEqualToString:[NSString string]]
        ? @"ocategoryid"
        : nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:sectionNameKeyPath
                                                                                   cacheName:NSStringFromClass([FoodCategory class])];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
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
