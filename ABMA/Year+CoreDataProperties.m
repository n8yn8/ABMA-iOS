//
//  Year+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Year"];
}

@dynamic bObjectId;
@dynamic created;
@dynamic info;
@dynamic updated;
@dynamic welcome;
@dynamic year;
@dynamic day;
@dynamic maps;
@dynamic sponsors;
@dynamic surveys;

@end
