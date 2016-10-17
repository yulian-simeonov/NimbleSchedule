//
//  NSCalendar+Components.h
//   NimbleSchedule
//
//  Created by Yurii Bogdan on 4/12/13.
//  Copyright (c) 2013 Yurii Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Components)

- (NSInteger)weekdayInDate:(NSDate*)date;
- (NSInteger)secondsInDate:(NSDate*)date;
- (NSInteger)minutesInDate:(NSDate*)date;
- (NSInteger)hoursInDate:(NSDate*)date;
- (NSInteger)daysInDate:(NSDate*)date;
- (NSInteger)monthsInDate:(NSDate*)date;
- (NSInteger)yearsInDate:(NSDate*)date;
- (NSInteger)eraInDate:(NSDate*)date;

- (NSInteger)weekOfMonthInDate:(NSDate*)date;
- (NSInteger)weekOfYearInDate:(NSDate*)date;

- (NSArray*)allDatesInWeek:(int)weekNumber;

@end
