//
//  Year+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic year;
@dynamic day;

@end
