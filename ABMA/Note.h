//
//  Note.h
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Paper;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Paper *paper;

@end
