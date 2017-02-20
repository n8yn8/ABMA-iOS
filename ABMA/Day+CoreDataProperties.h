//
//  Day+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Day+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) NSSet<Event *> *event;
@property (nullable, nonatomic, retain) Year *year;

@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet<Event *> *)values;
- (void)removeEvent:(NSSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
