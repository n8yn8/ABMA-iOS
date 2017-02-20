//
//  Note+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Note"];
}

@dynamic content;
@dynamic bObjectId;
@dynamic event;
@dynamic paper;

@end
