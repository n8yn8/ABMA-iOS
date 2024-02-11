//
//  Sponsor+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Sponsor+CoreDataProperties.h"

@implementation Sponsor (CoreDataProperties)

+ (NSFetchRequest<Sponsor *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Sponsor"];
}

@dynamic bObjectId;
@dynamic created;
@dynamic imageUrl;
@dynamic updated;
@dynamic url;
@dynamic year;

@end
