//
//  Paper+CoreDataProperties.h
//  ABMA
//
//  Created by Nathan Condell on 2/17/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Paper+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Paper (CoreDataProperties)

+ (NSFetchRequest<Paper *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *abstract;
@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) Event *event;
@property (nullable, nonatomic, retain) Note *note;

@end

NS_ASSUME_NONNULL_END
