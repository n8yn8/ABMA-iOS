//
//  Map+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//
//

#import "Map+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Map (CoreDataProperties)

+ (NSFetchRequest<Map *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) Year *year;

@end

NS_ASSUME_NONNULL_END
