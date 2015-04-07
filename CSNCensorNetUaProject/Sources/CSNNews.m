//
//  CSNNews.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNNews.h"

////////////////////////////////////////////////////////////////////////////////
@implementation CSNNews

@dynamic title, link, details, guid, pubDate, comments, enclosure, content;

- (NSString *)imagePath
{
	return CSNPathToStoredFileFromURLString(self.enclosure);
}

@end
