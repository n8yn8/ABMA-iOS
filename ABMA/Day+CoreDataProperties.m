//
//  Day+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Day+CoreDataProperties.h"

@implementation Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Day"];
}

@dynamic date;
@dynamic event;
@dynamic year;

@end
