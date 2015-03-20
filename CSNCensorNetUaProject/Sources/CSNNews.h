//
//  CSNNews.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
@interface CSNNews : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *details; // stands for 'description' node
@property (nonatomic, strong) NSURL *guid;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSURL *comments;
@property (nonatomic, copy) NSString *enclosure;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *content;

@end
