//
//  Day+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Day+CoreDataProperties.h"

@implementation Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Day"];
}

@dynamic date;
@dynamic event;
@dynamic year;

@end
