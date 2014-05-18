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
#import "FoodCategory+LocalizedViewModel.h"

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
    
    NSString *sortKey = [self getSortKey];
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"headcategoryid != %d", 15];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"localizedGroup"
                                                                                   cacheName:NSStringFromClass([FoodCategory class])];
}

- (NSString*)getSortKey {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class]) inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *unassociatedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];

    NSString *languageCode = [NSLocale preferredLanguages][0];
    NSString *localizedProperty = [NSString stringWithFormat:@"name_%@", languageCode];
    SEL localizedNameSelector = NSSelectorFromString(localizedProperty);
    
    return [unassociatedObject respondsToSelector:localizedNameSelector] ? localizedProperty : @"category";
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

- (FoodCategory*)getFoodCategoryForId:(NSInteger)categoryId {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"oid != %d", categoryId];
    fetchRequest.predicate = predicate;
    
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!results
        || results.count == 0)
        return nil;
    
    return results[0];
}

@end
