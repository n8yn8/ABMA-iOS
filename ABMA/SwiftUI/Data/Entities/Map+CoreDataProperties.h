//
//  Map+CoreDataProperties.h
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Map+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Map (CoreDataProperties)

+ (NSFetchRequest<Map *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, retain) Year *year;

@end

NS_ASSUME_NONNULL_END
