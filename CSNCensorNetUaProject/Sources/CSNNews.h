//
//  CSNNews.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

////////////////////////////////////////////////////////////////////////////////
@class CSNEnclosure;

////////////////////////////////////////////////////////////////////////////////
@interface CSNNews : NSManagedObject

@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSDate *pubDate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSSet *enclosure;
@end

@interface CSNNews (CoreDataGeneratedAccessors)

- (void)addEnclosureObject:(CSNEnclosure *)aValue;
- (void)removeEnclosureObject:(CSNEnclosure *)aValue;
- (void)addEnclosure:(NSSet *)aValues;
- (void)removeEnclosure:(NSSet *)aValues;

@end
