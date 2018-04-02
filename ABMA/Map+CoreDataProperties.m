//
//  Map+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//
//

#import "Map+CoreDataProperties.h"

@implementation Map (CoreDataProperties)

+ (NSFetchRequest<Map *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Map"];
}

@dynamic url;
@dynamic title;
@dynamic year;

@end
