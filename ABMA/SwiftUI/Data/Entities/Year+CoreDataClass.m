//
//  Year+CoreDataClass.m
//  ABMA
//
//  Created by Nathan Condell on 2/18/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

#import "Year+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Sponsor+CoreDataClass.h"
#import "Survey+CoreDataClass.h"
#import "Map+CoreDataClass.h"
@implementation Year

+ (Year *)getLatestYear:(NSString * _Nullable )selectedYear context:(NSManagedObjectContext *)context {
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.fetchLimit = 1;
    if (selectedYear) {
        yearRequest.predicate = [NSPredicate predicateWithFormat:@"year==%@", selectedYear];
    } else {
        yearRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId!=nil"];
    }
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    Year *year = [context executeFetchRequest:yearRequest error:&error].firstObject;
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    return year;
}

@end
