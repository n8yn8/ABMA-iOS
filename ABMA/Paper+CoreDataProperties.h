//
//  Paper+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Paper+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Paper (CoreDataProperties)

+ (NSFetchRequest<Paper *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *abstract;
@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, retain) Event *event;
@property (nullable, nonatomic, retain) Note *note;

@end

NS_ASSUME_NONNULL_END
