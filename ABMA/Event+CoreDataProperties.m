//
//  Event+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
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
@dynamic day;
@dynamic note;
@dynamic papers;

@end
