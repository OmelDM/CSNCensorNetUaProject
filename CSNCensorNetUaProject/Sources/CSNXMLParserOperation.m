//
//  CSNXMLParser.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNXMLParserOperation.h"
#import "CSNNews.h"
#import "CSNDownloader.h"

////////////////////////////////////////////////////////////////////////////////
NSString *const kItemName = @"item";
NSString *const kTitleName = @"title";
NSString *const kLinkName = @"link";
NSString *const kDescriptionName = @"description";
NSString *const kGuidName = @"guid";
NSString *const kPubDateName = @"pubDate";
NSString *const kCommentsName = @"comments";
NSString *const kContentName = @"content";
NSString *const kEnclosureName = @"enclosure";
NSString *const kURLName = @"url";

////////////////////////////////////////////////////////////////////////////////
@interface CSNXMLParserOperation () <NSXMLParserDelegate>

@property (nonatomic, copy) NSData *parsedData;
@property (nonatomic, strong) CSNNews *currentNews;
@property (nonatomic, strong) NSMutableArray *compositNews;
@property (nonatomic, strong) NSMutableString *currentCharacters;
@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, strong) NSArray *news;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNXMLParserOperation

- (instancetype)initWithData:(NSData *)aData
{
	self = [super init];
	
	if (nil != self)
	{
		self.parsedData = aData;
	}
	
	return self;
}

#pragma mark NSOperation overrode methods
- (void)main
{
	@try
	{
		NSXMLParser *theParser = [[NSXMLParser alloc] initWithData:self.parsedData];
		theParser.delegate = self;
		[theParser parse];
	}
	@catch(...)
	{
		#warning Handle exception
	}
}

#pragma mark NSXMLParserDelegate methods
- (void)parserDidStartDocument:(NSXMLParser *)aParser
{
	self.compositNews = [NSMutableArray new];
	self.currentCharacters = [NSMutableString new];
	self.dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
				error:NULL];
}

- (void)parserDidEndDocument:(NSXMLParser *)aParser
{
	self.news = [NSArray arrayWithArray:self.compositNews];
	self.compositNews = nil;
	self.currentNews = nil;
	self.currentCharacters = nil;
	self.dataDetector = nil;
}

- (void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)anElementName
			namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aName
			attributes:(NSDictionary *)anAttributeDictionary
{
	if ([anElementName isEqualToString:kItemName])
	{
		self.currentNews = [CSNNews new];
	}
	else if (nil != self.currentNews && ([anElementName isEqualToString:kTitleName] ||
				[anElementName isEqualToString:kLinkName] ||
				[anElementName isEqualToString:kDescriptionName] ||
				[anElementName isEqualToString:kGuidName] ||
				[anElementName isEqualToString:kPubDateName] ||
				[anElementName isEqualToString:kCommentsName] ||
				[anElementName isEqualToString:kContentName]))
	{
		[self.currentCharacters setString:@""];
	}
	else if (nil != self.currentNews && [anElementName isEqualToString:kEnclosureName])
	{
		NSString *theURL = anAttributeDictionary[kURLName];
		if (nil != theURL)
		{
			self.currentNews.enclosure = theURL;
			self.currentNews.imagePath = [[CSNDownloader sharedDownloader]
						addFileToDownloaderFromURL:[NSURL URLWithString:theURL]];
		}
	}

}

- (void)parser:(NSXMLParser *)aParser didEndElement:(NSString *)anElementName
			namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aName
{
	if (nil == self.currentNews)
	{
		return;
	}
	else if ([anElementName isEqualToString:kItemName])
	{
		[self.compositNews addObject:self.currentNews];
	}
	else if ([anElementName isEqualToString:kTitleName])
	{
		self.currentNews.title = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kLinkName])
	{
		self.currentNews.link = [NSURL URLWithString:self.currentCharacters];
	}
	else if ([anElementName isEqualToString:kDescriptionName])
	{
		self.currentNews.details = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kGuidName])
	{
		self.currentNews.guid = [NSURL URLWithString:self.currentCharacters];
	}
	else if ([anElementName isEqualToString:kPubDateName])
	{
		NSTextCheckingResult *theResult = [[self.dataDetector
					matchesInString:self.currentCharacters options:0
					range:NSMakeRange(0, self.currentCharacters.length)] lastObject];
		self.currentNews.pubDate = theResult.date;
	}
	else if ([anElementName isEqualToString:kCommentsName])
	{
		self.currentNews.comments = [NSURL URLWithString:self.currentCharacters];
	}
	else if ([anElementName isEqualToString:kContentName])
	{
		self.currentNews.content = [self cleanedContentStringFromString:self.currentCharacters];
	}
}

- (void)parser:(NSXMLParser *)aParser foundCharacters:(NSString *)aString
{
	[self.currentCharacters appendString:aString];
}

- (void)parser:(NSXMLParser *)aParser parseErrorOccurred:(NSError *)aParseError
{
	#warning Handle error
}

#pragma mark Private methods
- (NSString *)cleanedContentStringFromString:(NSString *)aString
{
	NSString *theResult = [aString stringByTrimmingCharactersInSet:[NSCharacterSet
					whitespaceAndNewlineCharacterSet]];
	theResult = [theResult stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n"];
	theResult = [theResult stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
	
	return theResult;
}

@end
