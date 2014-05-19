//
//  DatabaseReader.m
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "DatabaseReader.h"

@interface DatabaseReader ()

@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation DatabaseReader

- (NSInteger)numberOfSections {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (NSString*)getSectionTitleAtSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.name;
}

- (id)getObjectAtIndexPath:(NSIndexPath*)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

// Method should be overwritten by sub classes
- (void)fetchResultForSearchTerm:(NSString*)searchTerm {}

@end
