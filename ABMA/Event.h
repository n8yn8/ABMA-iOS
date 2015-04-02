//
//  Event.h
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Note, Paper;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * locatoin;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSOrderedSet *papers;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)insertObject:(Paper *)value inPapersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPapersAtIndex:(NSUInteger)idx;
- (void)insertPapers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePapersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPapersAtIndex:(NSUInteger)idx withObject:(Paper *)value;
- (void)replacePapersAtIndexes:(NSIndexSet *)indexes withPapers:(NSArray *)values;
- (void)addPapersObject:(Paper *)value;
- (void)removePapersObject:(Paper *)value;
- (void)addPapers:(NSOrderedSet *)values;
- (void)removePapers:(NSOrderedSet *)values;
@end
