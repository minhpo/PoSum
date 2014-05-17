//
//  ImportOperation.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImportOperation : NSOperation

- (id)initWithFileName:(NSString*)name forClass:(Class)targetClass withProgressCallback:(void(^)(float))progressCallback;

@end
