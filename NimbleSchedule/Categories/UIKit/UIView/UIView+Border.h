//
//  UIView+Border.h
//  NachumSegalNetwork
//
//  Created by Yurii Bogdan on 12/28/12.
//  Copyright (c) 2012 Yurii Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface UIView (Border)

- (void) showBorder;
- (void) hideBorder;

- (void) setBorderColor:(UIColor *)color;
- (void) setBorderWidth:(CGFloat)width;

@end
