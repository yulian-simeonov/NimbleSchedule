//
//  NSCalendar+DateComparison.h
//   NimbleSchedule
//
//  Created by Yurii Bogdan on 4/13/13.
//  Copyright (c) 2013 Yurii Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (DateComparison)

- (BOOL)date:(NSDate *)firstDate isSameDayAs:(NSDate *)anotherDate;
- (BOOL)date:(NSDate*)firstDate isSameWeekAs:(NSDate *)anotherDate;
- (BOOL)date:(NSDate*)firstDate isSameMonthAs:(NSDate *)anotherDate;
- (BOOL)date:(NSDate *)firstDate isSameYearAs:(NSDate *)anotherDate;
- (BOOL)date:(NSDate *)firstDate isSameEraAs:(NSDate *)anotherDate;

@end
