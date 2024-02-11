//
//  Map+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Map+CoreDataProperties.h"

@implementation Map (CoreDataProperties)

+ (NSFetchRequest<Map *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Map"];
}

@dynamic title;
@dynamic url;
@dynamic year;

@end
