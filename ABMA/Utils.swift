//
//  Utils.swift
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Foundation

class Utils: NSObject {
    static func timeFrame(startDate: Date, endDate: Date?) -> String {
        let timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.timeZone = timeZone
        var value = dateFormatter.string(from: startDate)
        if let end = endDate {
            value += " - \(dateFormatter.string(from: end))"
        }
        return value
    }
    
//    - (NSString *)timeFrameFromStart:(NSDate *)startDate toEnd:(NSDate *)endDate {
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
//    [timeFormatter setDateFormat:@"h:mma"];
//    [timeFormatter setTimeZone:timeZone];
//    NSMutableString *start = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:startDate]];
//    if (endDate) {
//    [start appendFormat:@" - %@", [timeFormatter stringFromDate:endDate]];
//    }
//    return start;
//    }
}
