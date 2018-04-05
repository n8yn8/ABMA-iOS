//
//  Survey+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/11/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//
//

#import "Survey+CoreDataProperties.h"

@implementation Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Survey"];
}

@dynamic title;
@dynamic details;
@dynamic url;
@dynamic start;
@dynamic end;
@dynamic year;

@end
