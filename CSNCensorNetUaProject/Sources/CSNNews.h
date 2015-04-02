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
@interface CSNNews : NSManagedObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *details; // stands for 'description' node
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSDate *pubDate;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *enclosure;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *content;

@end
