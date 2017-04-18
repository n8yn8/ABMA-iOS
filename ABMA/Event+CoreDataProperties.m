//
//  Event+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic bObjectId;
@dynamic details;
@dynamic endDate;
@dynamic locatoin;
@dynamic place;
@dynamic startDate;
@dynamic subtitle;
@dynamic title;
@dynamic created;
@dynamic updated;
@dynamic day;
@dynamic note;
@dynamic papers;

@end
