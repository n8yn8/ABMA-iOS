//
//  Survey+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 3/11/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//
//

#import "Survey+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSDate *start;
@property (nullable, nonatomic, copy) NSDate *end;
@property (nullable, nonatomic, retain) Year *year;

@end

NS_ASSUME_NONNULL_END
