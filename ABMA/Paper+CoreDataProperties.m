//
//  Paper+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Paper+CoreDataProperties.h"

@implementation Paper (CoreDataProperties)

+ (NSFetchRequest<Paper *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Paper"];
}

@dynamic abstract;
@dynamic author;
@dynamic title;
@dynamic bObjectId;
@dynamic event;
@dynamic note;

@end
