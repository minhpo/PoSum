//
//  DatabaseImportOperation.h
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shared.h"

@interface DatabaseImportOperation : NSOperation

- (id)initWithFileName:(NSString*)fileName forClass:(Class)targetClass withProgressCallback:(ProgressCallback)progressCallback;

@end
