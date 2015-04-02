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

@dynamic title, link, details, guid, pubDate, comments, enclosure, imagePath, content;

- (NSString *)description
{
	return [NSString stringWithFormat:@"News: %@\nPublication date: %@\nDetails: "
				"%@\nContent: %@\nPath to image: %@\nImage URL: %@\nLink: %@\n"
				"Comments: %@\nPersistant link: %@",
				self.title, [NSDateFormatter localizedStringFromDate:self.pubDate
				dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle],
				self.details, self.content, self.imagePath, self.enclosure,
				self.link, self.comments, self.guid];
}

@end
