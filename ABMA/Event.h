//
//  Event.h
//  ABMA
//
//  Created by Nathan Condell on 3/9/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * locatoin;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Note *note;

@end
