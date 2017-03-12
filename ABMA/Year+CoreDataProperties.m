//
//  Year+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic bObjectId;
@dynamic info;
@dynamic welcome;
@dynamic year;
@dynamic created;
@dynamic updated;
@dynamic day;
@dynamic sponsors;

@end
