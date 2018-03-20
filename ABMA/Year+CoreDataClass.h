//
//  Year+CoreDataClass.h
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Sponsor, Survey;

NS_ASSUME_NONNULL_BEGIN

@interface Year : NSManagedObject

+ (Year *)getLatestYear:( NSString * _Nullable )  selectedYear context:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Year+CoreDataProperties.h"
