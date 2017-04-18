//
//  Note+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Note"];
}

@dynamic bObjectId;
@dynamic content;
@dynamic updated;
@dynamic created;
@dynamic event;
@dynamic paper;

@end
