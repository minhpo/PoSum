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

static NSString *kFinishedImportNotification = @"kFinishedImportNotification";

typedef void(^ProgressCallback)(float);