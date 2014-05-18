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
    }
    
    return self;
}

- (void)setSearchTerm:(NSString*)searchTerm {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Exercise class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *sortKey = [self getSortKey];
    if (searchTerm) {
        NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"%K contains[c] %@", sortKey, searchTerm];        
        fetchRequest.predicate = predicate;
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    
    NSSortDescriptor *defaultSort = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    
    NSArray *sortDescriptors = [sortKey isEqualToString:@"title"]
        ? @[sort]
        : @[sort, defaultSort];

    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:NSStringFromClass([Exercise class])];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (NSString*)getSortKey {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Exercise class]) inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *unassociatedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    NSString *languageCode = [NSLocale preferredLanguages][0];
    NSString *localizedProperty = [NSString stringWithFormat:@"name_%@", languageCode];
    SEL localizedNameSelector = NSSelectorFromString(localizedProperty);
    
    return [unassociatedObject respondsToSelector:localizedNameSelector] ? localizedProperty : @"title";
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [DatabaseContext sharedInstance].persistentStoreCoordinator;
}

@end
