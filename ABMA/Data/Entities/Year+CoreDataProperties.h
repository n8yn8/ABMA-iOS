//
//  Year+CoreDataProperties.h
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Year+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, copy) NSString *welcome;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, retain) NSSet<Day *> *day;
@property (nullable, nonatomic, retain) NSSet<Map *> *maps;
@property (nullable, nonatomic, retain) NSSet<Sponsor *> *sponsors;
@property (nullable, nonatomic, retain) NSSet<Survey *> *surveys;

@end

@interface Year (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet<Day *> *)values;
- (void)removeDay:(NSSet<Day *> *)values;

- (void)addMapsObject:(Map *)value;
- (void)removeMapsObject:(Map *)value;
- (void)addMaps:(NSSet<Map *> *)values;
- (void)removeMaps:(NSSet<Map *> *)values;

- (void)addSponsorsObject:(Sponsor *)value;
- (void)removeSponsorsObject:(Sponsor *)value;
- (void)addSponsors:(NSSet<Sponsor *> *)values;
- (void)removeSponsors:(NSSet<Sponsor *> *)values;

- (void)addSurveysObject:(Survey *)value;
- (void)removeSurveysObject:(Survey *)value;
- (void)addSurveys:(NSSet<Survey *> *)values;
- (void)removeSurveys:(NSSet<Survey *> *)values;

@end

NS_ASSUME_NONNULL_END
