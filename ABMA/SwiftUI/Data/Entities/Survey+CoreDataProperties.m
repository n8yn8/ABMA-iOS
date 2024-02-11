//
//  Survey+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Survey+CoreDataProperties.h"

@implementation Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Survey"];
}

@dynamic details;
@dynamic end;
@dynamic start;
@dynamic title;
@dynamic url;
@dynamic year;

@end
