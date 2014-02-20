//
//  Record.h
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/16/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * name;

@end
