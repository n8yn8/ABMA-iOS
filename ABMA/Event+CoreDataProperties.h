//
//  Event+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSString *locatoin;
@property (nullable, nonatomic, copy) NSString *place;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSString *subtitle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, retain) Day *day;
@property (nullable, nonatomic, retain) Note *note;
@property (nullable, nonatomic, retain) NSOrderedSet<Paper *> *papers;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)insertObject:(Paper *)value inPapersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPapersAtIndex:(NSUInteger)idx;
- (void)insertPapers:(NSArray<Paper *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePapersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPapersAtIndex:(NSUInteger)idx withObject:(Paper *)value;
- (void)replacePapersAtIndexes:(NSIndexSet *)indexes withPapers:(NSArray<Paper *> *)values;
- (void)addPapersObject:(Paper *)value;
- (void)removePapersObject:(Paper *)value;
- (void)addPapers:(NSOrderedSet<Paper *> *)values;
- (void)removePapers:(NSOrderedSet<Paper *> *)values;

@end

NS_ASSUME_NONNULL_END
