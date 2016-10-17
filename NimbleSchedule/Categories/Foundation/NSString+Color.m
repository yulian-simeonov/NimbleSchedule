//
//  NSString+Color.m
//   NimbleSchedule
//
//  Created by Yurii Bogdan on 4/10/13.
//  Copyright (c) 2013 Yurii Bogdan. All rights reserved.
//

#import "NSString+Color.h"
#import "UIColor+HexString.h"

@implementation NSString (Color)

- (UIColor *)toColor
{
    return [UIColor colorWithHexString:self];
}

@end
