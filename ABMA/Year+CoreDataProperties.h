//
//  Year+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 4/7/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Year+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, copy) NSString *welcome;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *surveyLink;
@property (nullable, nonatomic, copy) NSDate *surveyStart;
@property (nullable, nonatomic, copy) NSDate *surveyEnd;
@property (nullable, nonatomic, retain) NSSet<Day *> *day;
@property (nullable, nonatomic, retain) NSSet<Sponsor *> *sponsors;

@end

@interface Year (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet<Day *> *)values;
- (void)removeDay:(NSSet<Day *> *)values;

- (void)addSponsorsObject:(Sponsor *)value;
- (void)removeSponsorsObject:(Sponsor *)value;
- (void)addSponsors:(NSSet<Sponsor *> *)values;
- (void)removeSponsors:(NSSet<Sponsor *> *)values;

@end

NS_ASSUME_NONNULL_END
