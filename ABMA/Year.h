//
//  Year.h
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Year : NSManagedObject

@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet *day;
@end

@interface Year (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet *)values;
- (void)removeDay:(NSSet *)values;

@end
