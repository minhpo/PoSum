//
//  DatabaseReader.h
//  PoSum
//
//  Created by Po Sam on 18/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseReader : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfObjectsInSection:(NSInteger)section;
- (NSString*)getSectionTitleAtSection:(NSInteger)section;
- (id)getObjectAtIndexPath:(NSIndexPath*)indexPath;
- (void)setSearchTerm:(NSString*)searchTerm;

@end
