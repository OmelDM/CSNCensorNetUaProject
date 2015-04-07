//
//  Enclosure.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 4/3/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

////////////////////////////////////////////////////////////////////////////////
@class CSNNews;

////////////////////////////////////////////////////////////////////////////////
@interface CSNEnclosure : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) CSNNews *news;

@end
