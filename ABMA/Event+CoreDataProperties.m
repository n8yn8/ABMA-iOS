//
//  Event+CoreDataProperties.m
//  ABMA
//
//  Created by Nate Condell on 1/15/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Event"];
}

@dynamic bObjectId;
@dynamic created;
@dynamic details;
@dynamic endDate;
@dynamic locatoin;
@dynamic place;
@dynamic startDate;
@dynamic subtitle;
@dynamic title;
@dynamic updated;
@dynamic day;
@dynamic note;
@dynamic papers;

@end
