//
//  Year+CoreDataProperties.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic bObjectId;
@dynamic created;
@dynamic info;
@dynamic updated;
@dynamic welcome;
@dynamic year;
@dynamic surveyLink;
@dynamic surveyStart;
@dynamic surveyEnd;
@dynamic day;
@dynamic sponsors;

@end
