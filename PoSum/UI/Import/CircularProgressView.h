//
//  CircularProgressView.h
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularProgressView : UIView

- (void)setLineWidth:(CGFloat)lineWidth;
- (void)setValue:(CGFloat)value;
- (void)setDrawColor:(UIColor*)color;

@end
