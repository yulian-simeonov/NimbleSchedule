//
//  NSLoadingButton.h
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/19/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Values for NSTextAlignment */


typedef enum {
    NSLoadingButtonAlignmentLeft      = 0,
    NSLoadingButtonAlignmentCenter    = 1,
    NSLoadingButtonAlignmentRight     = 2,
} NSLoadingButtonAlignment;


@interface NSLoadingButton : UIButton

@property (nonatomic, readwrite) BOOL loading;

@property(nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

@property(nonatomic) UIEdgeInsets activityIndicatorEdgeInsets; // default is UIEdgeInsetsZero

@property(nonatomic, readwrite) BOOL hideImageWhenLoading; // Default YES
@property(nonatomic, readwrite) BOOL hideTextWhenLoading; // Default YES

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle forState:(UIControlState)__state;
- (UIActivityIndicatorViewStyle)activityIndicatorStyleForState:(UIControlState)__state;
- (void)setActivityIndicatorAlignment:(NSLoadingButtonAlignment)_aligment;

@end
