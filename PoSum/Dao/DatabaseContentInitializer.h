//
//  DatabaseContentInitializer.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseContentInitializer : NSObject

- (void)startImportingDataWithProgressCallback:(ProgressCallback)progressCallback;

@end
