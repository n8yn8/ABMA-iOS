//
//  Paper+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Paper+CoreDataProperties.h"

@implementation Paper (CoreDataProperties)

+ (NSFetchRequest<Paper *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Paper"];
}

@dynamic abstract;
@dynamic author;
@dynamic title;
@dynamic event;
@dynamic note;

@end
