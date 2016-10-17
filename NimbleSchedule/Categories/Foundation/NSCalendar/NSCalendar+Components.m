//
//  NSCalendar+Components.m
//   NimbleSchedule
//
//  Created by Yurii Bogdan on 4/12/13.
//  Copyright (c) 2013 Yurii Bogdan. All rights reserved.
//

#import "NSCalendar+Components.h"

@implementation NSCalendar (Components)

- (NSInteger)weekOfMonthInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitWeekOfMonth fromDate:date];
    return [comps weekOfMonth];
}


- (NSInteger)weekOfYearInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitWeekOfYear fromDate:date];
    return [comps weekOfYear];
}

- (NSInteger)weekdayInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitWeekday fromDate:date];
    return [comps weekday];
}


- (NSInteger)secondsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitSecond fromDate:date];
    return [comps second];
}

- (NSInteger)minutesInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitMinute fromDate:date];
    return [comps minute];
}

- (NSInteger)hoursInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitHour fromDate:date];
    return [comps hour];
}

- (NSInteger)daysInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitDay fromDate:date];
    return [comps day];
}

- (NSInteger)monthsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitMonth fromDate:date];
    return [comps month];
}

- (NSInteger)yearsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitYear fromDate:date];
    return [comps year];
}

- (NSInteger)eraInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSCalendarUnitEra fromDate:date];
    return [comps era];
}

- (NSArray*)allDatesInWeek:(int)weekNumber {
    // determine weekday of first day of year:
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate *today = [NSDate date];
    
    NSDate *tomorrow = [self dateByAddingComponents:comps toDate:today options:0];
    const NSTimeInterval kDay = [tomorrow timeIntervalSinceDate:today];
    comps = [self components:NSCalendarUnitYear fromDate:[NSDate date]];
    comps.day = 1;
    comps.month = 1;
    comps.hour = 12;
    NSDate *start = [self dateFromComponents:comps];
    comps = [self components:NSCalendarUnitWeekday fromDate:start];
    if (weekNumber==1) {
        start = [start dateByAddingTimeInterval:-kDay*(comps.weekday-1)];
    } else {
        start = [start dateByAddingTimeInterval:
                 kDay*(8-comps.weekday+7*(weekNumber-2))];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        [result addObject:[start dateByAddingTimeInterval:kDay*i]];
    }
    return [NSArray arrayWithArray:result];
}

@end
