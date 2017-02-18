//
//  Event+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic details;
@dynamic endDate;
@dynamic locatoin;
@dynamic place;
@dynamic startDate;
@dynamic subtitle;
@dynamic time;
@dynamic title;
@dynamic bObjectId;
@dynamic day;
@dynamic note;
@dynamic papers;

@end
