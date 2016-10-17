//
//  NSDateComponents+AllComponents.m
//   NimbleSchedule
//
//  Created by Yurii Bogdan on 4/12/13.
//  Copyright (c) 2013 Yurii Bogdan. All rights reserved.
//

#import "NSDateComponents+AllComponents.h"

@implementation NSDateComponents (AllComponents)

#pragma mark - All Components

+ (NSUInteger)allComponents
{
return (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday);
}

@end
