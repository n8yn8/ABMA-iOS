//
//  Sponsor+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Sponsor+CoreDataProperties.h"

@implementation Sponsor (CoreDataProperties)

+ (NSFetchRequest<Sponsor *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Sponsor"];
}

@dynamic bObjectId;
@dynamic imageUrl;
@dynamic url;
@dynamic created;
@dynamic updated;
@dynamic year;

@end
