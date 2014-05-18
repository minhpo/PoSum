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
    }
    
    return self;
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

- (void)setSearchTerm:(NSString*)searchTerm {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *sortKey = [self getSortKey];
    NSPredicate *predicate = !searchTerm || [searchTerm isEqualToString:[NSString string]]
        ? [NSPredicate  predicateWithFormat:@"headcategoryid != %d", 15]
        : [NSPredicate  predicateWithFormat:@"headcategoryid != %d AND %K contains[c] %@", 15, sortKey, searchTerm];
    
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSString *sectionNameKeyPath = !searchTerm || [searchTerm isEqualToString:[NSString string]]
        ? @"localizedGroup"
        : nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:sectionNameKeyPath
                                                                                   cacheName:NSStringFromClass([FoodCategory class])];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (NSString*)getSortKey {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([FoodCategory class]) inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *unassociatedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    NSString *languageCode = [NSLocale preferredLanguages][0];
    NSString *localizedProperty = [NSString stringWithFormat:@"name_%@", languageCode];
    SEL localizedNameSelector = NSSelectorFromString(localizedProperty);
    
    return [unassociatedObject respondsToSelector:localizedNameSelector] ? localizedProperty : @"category";
}

@end
