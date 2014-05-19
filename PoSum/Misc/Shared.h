//
//  Shared.h
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TabBarTextFont [UIFont fontWithName:@"ChalkboardSE-Regular" size:11]
#define TableViewCellTextFont [UIFont fontWithName:@"ChalkboardSE-Regular" size:15]
#define TableViewCellDetailTextFont [UIFont fontWithName:@"ChalkboardSE-Regular" size:13]

#define LifesumGreen [UIColor colorWithRed:179.0/255.0 green:208.0/255.0 blue:60.0/255.0 alpha:1.0]
#define LifesumYellow [UIColor colorWithRed:255.0/255.0 green:191.0/255.0 blue:17.0/255.0 alpha:1.0]

static NSString *kFinishedImportNotification = @"kFinishedImportNotification";
static NSString *kFoodCategoryImageUrlTemplate = @"http://cdn.shapeupclub.com/photos/categories/%d/640x460.jpg?version=1";

typedef void(^ProgressCallback)(float);