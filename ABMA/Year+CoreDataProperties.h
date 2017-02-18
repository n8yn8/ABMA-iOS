//
//  Year+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Year+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, retain) NSSet<Day *> *day;

@end

@interface Year (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet<Day *> *)values;
- (void)removeDay:(NSSet<Day *> *)values;

@end

NS_ASSUME_NONNULL_END
