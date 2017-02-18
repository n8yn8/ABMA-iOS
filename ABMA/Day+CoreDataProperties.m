//
//  Day+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
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
