//
//  Paper.h
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Note;

@interface Paper : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Note *note;

@end
