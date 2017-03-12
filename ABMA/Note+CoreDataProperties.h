//
//  Note+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, retain) Event *event;
@property (nullable, nonatomic, retain) Paper *paper;

@end

NS_ASSUME_NONNULL_END
