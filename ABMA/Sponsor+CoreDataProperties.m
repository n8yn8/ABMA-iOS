//
//  Sponsor+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Sponsor+CoreDataProperties.h"

@implementation Sponsor (CoreDataProperties)

+ (NSFetchRequest<Sponsor *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Sponsor"];
}

@dynamic imageUrl;
@dynamic url;
@dynamic bObjectId;
@dynamic year;

@end
