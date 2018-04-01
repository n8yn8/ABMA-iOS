//
//  Year+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic bObjectId;
@dynamic created;
@dynamic info;
@dynamic updated;
@dynamic welcome;
@dynamic year;
@dynamic day;
@dynamic sponsors;
@dynamic surveys;
@dynamic maps;

@end
