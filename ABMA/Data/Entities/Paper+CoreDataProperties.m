//
//  Paper+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Paper+CoreDataProperties.h"

@implementation Paper (CoreDataProperties)

+ (NSFetchRequest<Paper *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Paper"];
}

@dynamic abstract;
@dynamic author;
@dynamic bObjectId;
@dynamic created;
@dynamic title;
@dynamic updated;
@dynamic event;
@dynamic note;

@end
