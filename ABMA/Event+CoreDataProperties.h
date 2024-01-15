//
//  Event+CoreDataProperties.h
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSString *locatoin;
@property (nullable, nonatomic, copy) NSString *place;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSString *subtitle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, retain) Day *day;
@property (nullable, nonatomic, retain) Note *note;
@property (nullable, nonatomic, retain) NSSet<Paper *> *papers;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPapersObject:(Paper *)value;
- (void)removePapersObject:(Paper *)value;
- (void)addPapers:(NSSet<Paper *> *)values;
- (void)removePapers:(NSSet<Paper *> *)values;

@end

NS_ASSUME_NONNULL_END
