//
//  Sponsor+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Sponsor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Sponsor (CoreDataProperties)

+ (NSFetchRequest<Sponsor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bObjectId;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, retain) Year *year;

@end

NS_ASSUME_NONNULL_END
